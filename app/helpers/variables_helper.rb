# frozen_string_literal: true

module VariablesHelper
  def display_formula(formula)
    Variable.all.each do |v|
      formula.gsub!("'#{v.name}'", "<strong>'#{link_to(v.name, v)}'</strong>")
      formula.gsub!("\"#{v.name}\"", "<strong>'#{link_to(v.name, v)}'</strong>")
    end
    formula.html_safe
  end

  def url?(string)
    string =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end

  def link_if_variable(variable_name)
    variable = Variable.where(name: variable_name)
    if variable.size.positive?
      link_to variable_name, variable.first
    else
      variable_name
    end
  end
end
