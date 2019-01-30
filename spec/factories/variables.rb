# frozen_string_literal: true

FactoryBot.define do
  factory :variable do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    href { Faker::Internet.url }
    spec { '{}' }
    created_at { DateTime.now.utc }
    updated_at { DateTime.now.utc }
    namespace { Faker::Lorem.word }
    value_type
    entity
    references { [] }
    unit { nil }
  end
end
