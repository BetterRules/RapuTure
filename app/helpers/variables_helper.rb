# frozen_string_literal: true

module VariablesHelper
  def display_formula(formula)
    Variable.all.each do |v|
      formula.gsub!("'#{v.name}'", "<strong>'#{link_to(v.name, v)}'</strong>")
    end
    formula.html_safe
  end
end
