# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariableParsingService do
  describe 'VariableParsingService' do
    let(:formula) do
      "def formula_2002(persons, period, parameters):
    biological_mother = persons('parental_leave__is_the_biological_mother', period)

    her_spouse = persons('parental_leave__is_spouse_or_partner_of_the_biological_mother', period)
    received_transferred_entitlement = persons('parental_leave__has_spouse_who_transferred_her_entitlement', period)

    other = persons('parental_leave__a_person_other_than_biological_mother_or_her_spouse', period)
    permanent = persons('parental_leave__taking_permanent_primary_responsibility_for_child', period)

    # Mark who is the principal caregiver, as there may be >1 eligible
    # PPL Section 7 (2)
    nominated = persons.has_role(Family.PRINCIPAL_CAREGIVER)

    return nominated * (biological_mother + (her_spouse * received_transferred_entitlement) + (other * permanent))"
    end

    it { expect(VariableParsingService.formula_mentions_variable?(formula, 'parental_leave__is_the_biological_mother')).to eq true }
    it { expect(VariableParsingService.formula_mentions_variable?(formula, 'parental_leave__is_spouse_or_partner_of_the_biological_mother')).to eq true }
    it { expect(VariableParsingService.formula_mentions_variable?(formula, 'parental_leave__a_person_other_than_biological_mother_or_her_spouse')).to eq true }
    it { expect(VariableParsingService.formula_mentions_variable?(formula, 'parental_leave__taking_permanent_primary_responsibility_for_child')).to eq true }
    it { expect(VariableParsingService.formula_mentions_variable?(formula, 'age')).to eq false }

    let(:names) do
      %w[
        parental_leave__is_the_biological_mother
        parental_leave__is_spouse_or_partner_of_the_biological_mother
        parental_leave__a_person_other_than_biological_mother_or_her_spouse
        parental_leave__taking_permanent_primary_responsibility_for_child
      ]
    end

    before do
      names.each do |n|
        FactoryBot.create(:variable, name: n)
      end
    end
    it { expect(VariableParsingService.parse_mentioned_variables(formula)).to eq names }
  end

  describe 'parse_namespace' do
    it { expect(VariableParsingService.parse_namespace('parental_leave__is_the_biological_mother')).to eq 'parental_leave' }
    it { expect(VariableParsingService.parse_namespace('age')).to eq nil }
  end
end
