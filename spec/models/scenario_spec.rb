# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scenario, type: :model do
  context 'when I use FactoryBot to create a Scenario instance' do
    subject { FactoryBot.build(:scenario) }

    it { is_expected.to be_valid }
  end
end
