# frozen_string_literal: true

require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let(:value_type) { FactoryBot.create :value_type, name: 'int' }

  let(:simple_input_hash) do
    {"age"=>30, "is_nz_citizen"=>true, "social_security__is_ordinarily_resident_in_new_zealand"=>true, "social_security__has_accomodation_costs"=>true, "eligible_for_social_housing"=>false, "accommodation_supplement__below_income_threshold"=>true, "accommodation_supplement__below_cash_threshold"=>true}
  end
  let(:simple_output_hash) do
    {"social_security__eligible_for_accommodation_supplement"=>true}
  end
  let(:one_level_input_hash) do
    {
      'persons' => {
        'fulltime_uni_student' => {
          'age' => 21,
          'is_nz_citizen' => true,
          'social_security__is_ordinarily_resident_in_new_zealand' => true,
          'student_allowance__is_tertiary_student' => true,
          'student_allowance__is_enrolled_fulltime' => true,
          'student_allowance__meets_attendance_and_performance_requirements' => true
        }
      }
    }
  end
  let(:one_level_output_hash) do
    { 'student_allowance__eligible_for_basic_grant' => [true] }
  end
  let(:expected_variables) do
    %w[age is_nz_citizen social_security__is_ordinarily_resident_in_new_zealand
       student_allowance__is_tertiary_student student_allowance__is_enrolled_fulltime
       student_allowance__meets_attendance_and_performance_requirements
       student_allowance__eligible_for_basic_grant]
  end
  let!(:person) do
    FactoryBot.create :entity,
                      name: 'person',
                      description: 'this is a human being',
                      documentation: 'you, me, everyone'
  end
  let!(:one_level_scenario) do
    FactoryBot.create :scenario,
                      name: 'Student Allowance',
                      inputs: one_level_input_hash,
                      outputs: one_level_output_hash,
                      period: '2019-05',
                      error_margin: 1.0,
                      namespace: 'ghostchips'
  end
  let!(:nested_scenario) do
    FactoryBot.create :scenario,
                      name: 'Young Parent Payment',
                      inputs: simple_input_hash,
                      outputs: simple_output_hash,
                      period: '2019-05',
                      error_margin: 1.0,
                      namespace: 'social_security'
  end
  let(:variable) do
    FactoryBot.create :variable, entity: person,
                                 name: 'is_eligible_for_chocolate',
                                 description: 'is eligible for chocolate',
                                 namespace: 'chocolate',
                                 value_type: value_type
  end
  before do
    FactoryBot.create :variable,
                      name: 'first_variable',
                      entity: person,
                      description: 'this one was first',
                      namespace: 'humans',
                      value_type: value_type
    FactoryBot.create :variable,
                      name: 'second_variable',
                      entity: person,
                      description: 'and this one was second',
                      namespace: 'humans',
                      value_type: value_type

  end
  it 'loads homepage' do
    visit root_path
    Percy.snapshot(page, name: 'homepage')
  end
  it 'entities#index' do
    visit entities_path
    Percy.snapshot(page, name: 'entities#index')
  end
  it 'entities#show' do
    visit entity_path(person)
    Percy.snapshot(page, name: 'entities#show')
  end
  it 'variables#index' do
    visit variables_path
    Percy.snapshot(page, name: 'variables#index')
  end
  it 'variables#show' do
    visit variable_path(variable)
    Percy.snapshot(page, name: 'variables#show')
  end
  it 'scenarios#index' do
    visit scenarios_path
    Percy.snapshot(page, name: 'scenarios#index')
  end

  it 'scenarios#show' do
    expected_variables.each do |variable_name|
      FactoryBot.create :variable, name: variable_name,
                                   namespace: 'percy',
                                   entity: person,
                                   description: "a very good #{variable_name}"
    end
    one_level_scenario.parse_variables!
    nested_scenario.parse_variables!
    visit scenario_path(one_level_scenario)
    Percy.snapshot(page, name: 'scenarios#show')
    visit scenario_path(nested_scenario)
    Percy.snapshot(page, name: 'scenarios#show-nested')
  end
end
