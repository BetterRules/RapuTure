# frozen_string_literal: true

class VariableParsingService
  def self.parse_mentioned_variables(formula)
    mentioned = []
    Variable.all.pluck(:name).each do |variable_name|
      if formula_mentions_variable?(formula, variable_name)
        mentioned << variable_name
      end
    end
    mentioned
  end

  def self.formula_mentions_variable?(formula, variable_name)
    formula.include?("'#{variable_name}'") || formula.include?("\"#{variable_name}\"")
  end

  # Parse an OpenFisca variable name and return the namespace portion if it exists
  #
  # By our convention anything preceding +__+ (two underscores) is the namespace
  #
  # @return String
  def self.parse_namespace(name)
    name.split('__')[0] if name.include? '__'
  end
end
