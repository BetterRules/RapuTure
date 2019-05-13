# frozen_string_literal: true

class ScenarioVariable < ApplicationRecord
  belongs_to :scenario
  belongs_to :variable
  validates :direction, presence: true, inclusion: { in: %w[input output], message: '%{value} is not a valid direction' }
  scope :input, -> { where(direction: 'input')}
  scope :output, -> { where(direction: 'output')}
end
