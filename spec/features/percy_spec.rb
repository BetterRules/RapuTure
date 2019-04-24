# frozen_string_literal: true

require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  it 'loads homepage' do
    person = FactoryBot.create :entity, name: 'person'
    FactoryBot.create :variable, name: 'first_variable', entity: person
    FactoryBot.create :variable, name: 'second_variable', entity: person
    visit root_path
    Percy.snapshot(page)
  end
end
