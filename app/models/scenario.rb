# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_many :scenario_variables, dependent: :destroy
  has_many :variables, through: :scenario_variables, dependent: :destroy
  has_many :input_variables, through: :scenario_variables, dependent: :destroy
  has_many :output_variables, through: :scenario_variables, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def input_persons
    inputs.fetch 'persons', {}
  end

  def input_families
    inputs.fetch 'families', {}
  end

  def input_titled_properties
    inputs.fetch 'titled_properties', {}
  end

  def other_input_keys
    keys = inputs.keys
    keys - %w[persons families titled_properties]
  end

  def input_variables
    variables.merge(ScenarioVariable.input)
  end

  def output_variables
    variables.merge(ScenarioVariable.output)
  end

  def parse_variables!
    input_variables = Variable.where(name: get_all_keys(inputs))
    output_variables = Variable.where(name: get_all_keys(outputs))

    scenario_variables.where.not(variable: input_variables + output_variables)
                      .destroy_all

    input_variables.each do |v|
      ScenarioVariable.create! scenario: self, variable: v, direction: 'input'
    end
    output_variables.each do |v|
      ScenarioVariable.create! scenario: self, variable: v, direction: 'output'
    end
  end

  private

  # This could use some refinement
  # Currently it is returning all the keys
  # Can't just user lower level though because of data structures like:
  #  output:
  #   best_start__tax_credit_per_child:
  #     2018-07: [0, 0, 0, 260 ]
  def get_all_keys(hash)
    hash.each_with_object([]) do |(k, v), keys|
      keys << k
      keys.concat(get_all_keys(v)) if v.is_a? Hash
    end
  end
end
