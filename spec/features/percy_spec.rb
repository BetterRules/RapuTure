# frozen_string_literal: true

require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let(:value_type) { FactoryBot.create :value_type, name: 'int' }
  let!(:person) { FactoryBot.create :entity, name: 'person', documentation: 'this is a human being' }
  let(:variable) do
    FactoryBot.create :variable, entity: person,
      name: 'is_eligible_for_chocolate',
      description: 'is eligible for chocolate',
      namespace: 'chocolate',
      value_type: value_type
  end
  before do
    FactoryBot.create :variable,
      name: 'first_variable', entity: person, description: 'this one was first',
        namespace: 'humans',
        value_type: value_type
    FactoryBot.create :variable,
      name: 'second_variable', entity: person, description: 'and this one was second',
        namespace: 'humans',
        value_type: value_type
  end
  it 'loads homepage' do
    visit root_path
    Percy.snapshot(page, name: 'homepage')
  end
  it 'variables#index' do
    visit variables_path
    Percy.snapshot(page, name: 'variables#index')
  end
  it 'variables#show' do
    visit variable_path(variable)
    Percy.snapshot(page, name: 'variables#show')
  end
end
