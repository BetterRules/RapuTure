# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Variable, type: :model do
  context 'when I use FactoryBot to create a Variable instance' do
    subject { FactoryBot.build(:variable) }

    it { is_expected.to be_valid }
  end

  describe 'links' do
    let!(:parent) do
      FactoryBot.create :variable, reversed_variables: [child1,
                                                        child2]
    end
    let(:child1) { FactoryBot.create :variable }
    let(:child2) { FactoryBot.create :variable }

    let(:notused) { FactoryBot.create :variable }

    it { expect(parent.inbound_links.size).to eq 2 }
    it { expect(parent.outbound_links.size).to eq 0 }
    it { expect(parent.notused?).to be false }

    it { expect(child1.outbound_links.size).to eq 1 }
    it { expect(child1.inbound_links.size).to eq 0 }
    it { expect(child1.notused?).to be false }

    it { expect(child2.outbound_links.size).to eq 1 }
    it { expect(child2.inbound_links.size).to eq 0 }
    it { expect(child2.notused?).to be false }

    it { expect(notused.notused?).to be true }
    it { expect(notused.inbound_links.size).to be 0 }
    it { expect(notused.outbound_links.size).to be 0 }
  end
end
