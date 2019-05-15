# frozen_string_literal: true

require 'rails_helper'

describe 'index' do
  before do
    FactoryBot.create :variable, name: 'fulltime_uni_student'
    FactoryBot.create :variable, name: 'is_nz_citizen'
    FactoryBot.create :scenario,
                      name: 'a complicated situation',
                      inputs: {
                        'persons' => { 'fulltime_uni_student' => { 'age' => 21, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__is_enrolled_fulltime' => true, 'student_allowance__meets_attendance_and_performance_requirements' => true }, 'Parttime_student' => { 'age' => 18, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__approved_to_study_parttime' => true }, 'Overseas_student' => { 'age' => 27, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__approved_to_study_overseas' => true }, 'Refugee' => { 'age' => 25, 'immigration__is_recognised_refugee' => true, 'student_allowance__is_tertiary_student' => true, 'student_allowance__is_enrolled_fulltime' => true, 'student_allowance__meets_attendance_and_performance_requirements' => true }, 'Not_a_student' => { 'age' => 50, 'is_nz_citizen' => true, 'social_security__is_ordinarily_resident_in_new_zealand' => true, 'student_allowance__is_tertiary_student' => false } }, 'families' => { 'Whanau' => { 'others' => %w[fulltime_uni_student Overseas_student Refugee Not_a_student Parttime_student] } }, 'titled_properties' => { 'whare' => { 'others' => %w[
                          fulltime_uni_student Overseas_student Refugee Not_a_student Parttime_student
                        ] } }
                      },
                      outputs: { 'student_allowance__eligible_for_basic_grant' => [
                        true, true, true, true, false
                      ] },
                      period: '2019-05',
                      error_margin: 1.0,
                      namespace: 'ghostchips'
  end
  describe 'view all scenarios' do
    before { visit scenarios_path }
    it { expect(page).to have_link 'a complicated situation' }
  end
end
