# frozen_string_literal: true

FactoryBot.define do
  factory :scenario do
    name { Faker::Name.name }
    inputs { Faker::Json }
    period { Faker::Name.name }
    error_margin { Faker::Number.within(1..100) }
    created_at { DateTime.now.utc }
    updated_at { DateTime.now.utc }
    namespace { Faker::Quote.yoda }
  end
end
