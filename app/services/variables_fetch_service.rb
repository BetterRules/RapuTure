# frozen_string_literal: true

class VariablesFetchService < OpenfiscaService
  # Load all variables from the OpenFisca server into the database
  #
  # Updates existing database records and removes old records no longer
  # mentioned by the OpenFisca server
  #
  # @return [Enumerable<Variable>] the loaded +Variable+s, as a streamed
  #   enumerable
  def self.process_all
    # @return [Array<Array<(String, Hash{String, String})>>] a list of pairs
    # containing the name of an OpenFisca variable and a hash of some attributes
    # of the variable
    variables = []
    fetch_all.each do |name, attributes|
      variables << Variable.find_or_create_by!(name: name)
    end

    remove_stale_variables(variables.pluck(:name))

    variables.each do |variable|
      self.process_one(variable)
    end
  end
  # Remove from the database any variables not named in the parameter. Use this
  # method to remove old entries when the latest Variables list is retrieved
  # from the OpenFisca server.
  #
  # @param [Hash<string, _>]
  #
  # @return [Array<Variable>] The variables removed
  def self.remove_stale_variables(current_variables)
    Variable
      .where
      .not(name: current_variables)
      .delete_all
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
  def self.process_one(variable)
    puts variable

    ActiveRecord::Base.transaction do
      spec = fetch_one(variable.name)
      variable.spec = spec
      variable.references = spec['references']
      variable.description = spec['description']
      variable.value_type = ValueType.find_or_create_by!(name: spec['valueType'])
      variable.entity = Entity.find_or_create_by!(name: spec['entity'])
      variable.period = Period.find_or_create_by!(name: spec['definitionPeriod'])
      variable.namespace = VariableParsingService.parse_namespace(variable.name)
      variable.save!

      if variable.has_formula?
        variable.formulas.each do |date, formula|
          mentioned_variables = VariableParsingService.parse_mentioned_variables(formula['content'])
          variable.variables = Variable.where(name: mentioned_variables)
        end
      end

      variable
    end
  end

  def self.fetch_all
    of_conn.get('variables').body
  end

  def self.fetch_one(name)
    of_conn.get("variable/#{CGI.escape(name)}").body
  end
end
