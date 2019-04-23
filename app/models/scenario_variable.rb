# frozen_string_literal: true

class ScenarioVariable < ApplicationRecord
  belongs_to :scenario
  belongs_to :variable
end
