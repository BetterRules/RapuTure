# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Variable, type: :model do
  context 'when I use FactoryBot to create a Variable instance' do
    subject { FactoryBot.build(:variable) }

    it { is_expected.to be_valid }
  end
end
