# frozen_string_literal: true

class Period < ApplicationRecord
  validates :name, presence: true
end
