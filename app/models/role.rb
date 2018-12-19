# frozen_string_literal: true

class Role < ApplicationRecord
  belongs_to :entity

  def to_s
    "#{entity.name}.#{name}"
  end
end
