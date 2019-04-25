# frozen_string_literal: true

require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let!(:person) { FactoryBot.create :entity, name: 'person', description: 'this is a human being' }
  let(:variable) { FactoryBot.create :variable, entity: person, name: 'is_eligible_for_chocolate', description: 'is eligible for chocolate'}
  before do
    FactoryBot.create :variable,
      name: 'first_variable', entity: person, description: 'this one was first'
    FactoryBot.create :variable,
      name: 'second_variable', entity: person, description: 'and this one was second'
  end
  it 'loads homepage' do
    visit root_path
    Percy.snapshot(page)
  end
  it 'variables#index' do
    visit variables_path
    Percy.snapshot(page)
  end
  it 'variables#show' do
    visit variable_path(variable)
    Percy.snapshot(page)
  end
end
