# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_many :scenario_variables, dependent: :destroy
  has_many :variables, through: :scenario_variables

  validates :name, presence: true, uniqueness: true
end
