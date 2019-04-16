# frozen_string_literal: true

class Scenario < ApplicationRecord
  belongs_to :scenario
  belongs_to :variable
end
