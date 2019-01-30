# frozen_string_literal: true

FactoryBot.define do
  factory :value_type do
    name { Faker::Lorem.word }
    created_at { DateTime.now.utc }
    updated_at { DateTime.now.utc }
  end
end
