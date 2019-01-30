# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    documentation { Faker::Lorem.paragraph }
    plural { Faker::Name.name }
    created_at { DateTime.now.utc }
    updated_at { DateTime.now.utc }
  end
end
