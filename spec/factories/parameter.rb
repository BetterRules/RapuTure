# frozen_string_literal: true

FactoryBot.define do
  factory :parameter do
    description { Faker::Name.name }
    href { Fake::Name.name }
    brackets { Faker::Json }
    values { Faker::Json }
    filename { Faker::Name.name }
  end
end
