# frozen_string_literal: true

module VariablesHelper
  def display_formula(formula)
    Variable.all.each do |v|
      formula.gsub!("'#{v.name}'", "<strong>'#{link_to(v.name, v)}'</strong>")
      formula.gsub!("\"#{v.name}\"", "<strong>'#{link_to(v.name, v)}'</strong>")
    end
    formula.html_safe
  end

  def is_url?(string)
    string =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end
end
