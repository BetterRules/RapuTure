# frozen_string_literal: true

class VariablesFetchService
  # Load all variables from the OpenFisca server into the database
  #
  # Updates existing database records but does not remove old records no longer
  # mentioned by the OpenFisca server
  #
  # Returns the loaded Variables, as a streamed enumerable
  def self.fetch_all
    variables_list.keys.each do |name|
      variable = Variable.find_or_initialize_by(name: name)
      fetch(variable)
      yield variable
    end
  end

  # Load the full data of a variable into the database
  #
  # The parameter is a Variable containing the short info (only :name is
  # required) such as loaded from .variables_list, which does not yet contain
  # the full data for the Variable. This method will load the remaining data and
  # save the object.
  #
  # Returns the supplied Variable (which has had its full data loaded and saved to the database)
  def self.fetch(variable)
    spec = variable(name: variable.name)

    ActiveRecord::Base.transaction do
      variable.spec = spec
      variable.href = spec['href']
      variable.unit = spec['unit']
      variable.description = spec['description']
      variable.value_type = ValueType.find_or_create_by!(name: spec['valueType'])
      variable.entity = Entity.find_or_create_by!(name: spec['entity'])
      variable.namespace = parse_namespace(variable.name)
      variable.save!

      # variable.variables.clear

      if variable.has_formula?
        variable.spec['formulas'].each do |_d, formula|
          Variable.all.each do |v|
            # Make a copy, so we don't look it up every check
            linked_variables = variable.variables
            # Is this variable refences
            if formula['content'].include?("'#{v.name}'") || formula['content'].include?("\"#{v.name}\"")
              # Add it to .variables, if it's not there
              variable.variables << v unless linked_variables.include? v
            else
              # remove it from from .varibles if it's there
              variable.variables.delete(v) if linked_variables.include? v
            end
          end
        end
      end

      variable
    end
  end

  # Retrieve the short info (name, description, href) of all variables from the
  # OpenFisca server
  def self.variables_list
    of_conn.get('variables').body
  end

  # Retrieve the full data of one variable from the OpenFisca server
  def self.variable(name:)
    of_conn.get("variable/#{name}").body
  end

  def self.parse_namespace(name)
    name.split('__')[0] if name.include? '__'
  end

  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
