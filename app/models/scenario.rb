# frozen_string_literal: true

class Scenario < ApplicationRecord
  has_many :scenario_variables, dependent: :destroy
  has_many :variables, through: :scenario_variables, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
