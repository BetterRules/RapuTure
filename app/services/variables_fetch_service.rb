# frozen_string_literal: true

class VariablesFetchService
  # Load all variables from the OpenFisca server into the database
  #
  # Updates existing database records but does not remove old records no longer
  # mentioned by the OpenFisca server
  #
  # @return [Enumerable<Variable>] the loaded +Variable+s, as a streamed
  #   enumerable
  def self.fetch_all
    variables_list.each do |v|
      # variables_list returns a small data structure which has the variable
      # name as a key and other attributes as a hash
      variable_name = v.first
      variable_attributes = v.second

      # Find or create the Variable model using the name as the key
      variable = Variable.find_or_initialize_by(name: variable_name)

      # Update the model with attributes retrieved from the server
      # Note that the href value is available here but is not populated in .fetch below
      variable.update(variable_attributes)

      # Fetch the additional attributes from the server and save to the database
      fetch(variable)

      yield variable if block_given?
    end

    variable_names = variables_list.keys
    stale_variables = Variable.where.not(name: variable_names)
    stale_variables.each(&:destroy)

    variables_list unless block_given?
  end

  # Load the full data of a variable into the database
  #
  # @param variable [Variable, #name] a +Variable+ with some unset attributes, such as
  #   loaded from {variables_list}, which does not yet contain the full data
  #   available from the server. This method will load the remaining data and
  #   save the object into the local database. The +name+ attribute must be set
  #   to perform the lookup.
  #
  # @return [Variable] The same +Variable+ supplied as the parameter (which has
  #   been updated with the attributes retrieved from the server)
  def self.fetch(variable)
    spec = variable(name: variable.name)

    ActiveRecord::Base.transaction do
      variable.spec = spec
      variable.references = spec['references']
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
  # OpenFisca server. Full info can be loaded for each variable by passing it
  # to {fetch}
  #
  # @return [Array<Array<(String, Hash{String, String})>>] a list of pairs
  #   containing the name of an OpenFisca variable and a hash of some attributes
  #   of the variable
  def self.variables_list
    of_conn.get('variables').body
  end

  # Retrieve the full data of one variable from the OpenFisca server
  #
  # @param name [String] The name of a variable which exists on the OpenFisca server
  # @return [Array<(String, Hash{String, String})>]
  def self.variable(name:)
    of_conn.get("variable/#{CGI.escape(name)}").body
  end

  # Parse an OpenFisca variable name and return the namespace portion if it exists
  #
  # By our convention anything preceding +__+ (two underscores) is the namespace
  #
  # @return String
  def self.parse_namespace(name)
    name.split('__')[0] if name.include? '__'
  end

  # Get a connection to the OpenFisca server
  #
  # Uses the environment variable +OPENFISCA_URL+
  #
  # @return [Faraday::Connection]
  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
