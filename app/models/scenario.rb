# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_many :scenario_variables, dependent: :destroy
  has_many :variables, through: :scenario_variables, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def parse_variables!
    input_keys = get_all_keys(inputs)
    output_keys = get_all_keys(outputs)
    input_output_keys = input_keys + output_keys

    # byebug
    # # ensure they exist
    # input_output_keys.each do |variable_name|
    #   byebug
    #   Variable.find_or_create_by(name: variable_name)
    # end
    self.variables = Variable.where(name: input_output_keys)
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
