# frozen_string_literal: true

require 'rails_helper'

feature 'index' do
  let(:input_hash) do
    { 'persons' => { 'fulltime_uni_student' => { 'age' => 21, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__is_enrolled_fulltime' => true, 'student_allowance__meets_attendance_and_performance_requirements' => true }, 'Parttime_student' => { 'age' => 18, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__approved_to_study_parttime' => true }, 'Overseas_student' => { 'age' => 27, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__approved_to_study_overseas' => true }, 'Refugee' => { 'age' => 25, 'immigration__is_recognised_refugee' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__is_enrolled_fulltime' => true, 'student_allowance__meets_attendance_and_performance_requirements' => true }, 'Not_a_student' => { 'age' => 50, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => false } }, 'families' => { 'Whanau' => { 'others' => %w[fulltime_uni_student Overseas_student Refugee Not_a_student Parttime_student] } }, 'titled_properties' => { 'whare' => { 'others' => %w[fulltime_uni_student Overseas_student Refugee Not_a_student Parttime_student] } } }
  end
  let(:output_hash) do
    { 'student_allowance__eligible_for_basic_grant' => [true, true, true, true, false] }
  end
  let(:our_scenario) do
    FactoryBot.create :variable, name: 'age', description: 'age in years'
    FactoryBot.create :variable, name: 'is_nz_citizen', description: 'is a new zealand citizen'
    scen = FactoryBot.create :scenario, name: 'a complicated situation',
                                        inputs: input_hash,
                                        outputs: output_hash,
                                        period: '2019-05',
                                        error_margin: 1.0,
                                        namespace: 'ghostchips'
    scen.parse_variables!
    scen
  end
  describe 'view all scenarios' do
    before { visit scenario_path(our_scenario) }
    it { expect(page).to have_text 'age in years' }
    it { expect(page).to have_text 'is a new zealand citizen' }
  end
end
