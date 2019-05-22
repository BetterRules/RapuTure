# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scenario, type: :model do
  context 'when I use FactoryBot to create a Scenario instance' do
    subject { FactoryBot.build(:scenario) }

    it { is_expected.to be_valid }
  end

  describe 'parsing variables' do
    let(:input_hash) do
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
    let(:output_hash) do
      { 'student_allowance__eligible_for_basic_grant' => [true] }
    end
    let(:expected_variables) do
      expected_input_variables + expected_output_variables
    end
    let(:expected_input_variables) do
      %w[age is_nz_citizen social_security__is_ordinarily_resident_in_new_zealand
         student_allowance__is_tertiary_student student_allowance__is_enrolled_fulltime
         student_allowance__meets_attendance_and_performance_requirements]
    end
    let(:expected_output_variables) do
      ['student_allowance__eligible_for_basic_grant']
    end
    let!(:complicated_scenario) do
      expected_variables.each do |variable_name|
        FactoryBot.create :variable, name: variable_name
      end
      FactoryBot.create :scenario,
                        name: 'a complicated situation',
                        inputs: input_hash,
                        outputs: output_hash,
                        period: '2019-05',
                        error_margin: 1.0,
                        namespace: 'ghostchips'
    end
    before { complicated_scenario.parse_variables! }
    it { expect(complicated_scenario.variables.pluck(:name)).to eq expected_variables }
    it { expect(complicated_scenario.input_variables.pluck(:name)).to eq expected_input_variables }
    it { expect(complicated_scenario.output_variables.pluck(:name)).to eq expected_output_variables }
    describe 'only allows input/output variables' do
      it { expect { ScenarioVariable.create! variable: variable, scenario: scenario }.to raise_error }
      it { expect { ScenarioVariable.create! variable: variable, scenario: scenario, direction: 'down' }.to raise_error }
    end
    describe 'no duplicates allowed' do
      subject { complicated_scenario.output_variables.pluck(:name) }
      it do
        complicated_scenario.parse_variables!
        expect(subject).to eq ['student_allowance__eligible_for_basic_grant']
        complicated_scenario.parse_variables!
        expect(subject).to eq ['student_allowance__eligible_for_basic_grant']
      end
    end
    describe 'removes variables we no longer refer to' do
      it do
        FactoryBot.create :variable, name: 'hates_marshmallows'
        complicated_scenario.update!(outputs: { "hates_marshmallows": [true] })
        complicated_scenario.parse_variables!
        expect(complicated_scenario.output_variables.pluck(:name)).to eq ['hates_marshmallows']
      end
    end
  end
end
