# frozen_string_literal: true

FactoryBot.define do
  factory :period do
    name { Faker::Name.name }
  end
end
