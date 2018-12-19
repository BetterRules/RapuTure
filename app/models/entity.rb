# frozen_string_literal: true

class Entity < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :roles
  has_many :variables

  def to_s
    name
  end
end
