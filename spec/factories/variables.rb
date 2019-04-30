# frozen_string_literal: true

FactoryBot.define do
  factory :variable do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
    description { Faker::Lorem.paragraph }
    href { Faker::Internet.url }
    spec { '{"definitionPeriod": "MONTH"}' }
    created_at { DateTime.now.utc }
    updated_at { DateTime.now.utc }
    namespace { Faker::Lorem.word }
    value_type { FactoryBot.create :value_type, name: 'int' }
    entity
    references { [] }
    unit { nil }
  end
end
