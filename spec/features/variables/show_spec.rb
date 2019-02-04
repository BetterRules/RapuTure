# frozen_string_literal: true

require 'rails_helper'

feature 'show' do
  context 'Variable is orphaned' do
    let(:variable) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate' }
    describe 'view all variables' do
      before { visit variable_path(variable) }
      it { expect(page).to have_content variable.name }
      it { expect(page).to have_text 'Orphaned' }
    end
  end

  context 'Variable refers to others' do
    let!(:parent) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate', variables: [child] }
    let!(:child) { FactoryBot.create :variable, name: 'likes_to_eat' }
    describe 'view all variables' do
      before { visit variable_path(child) }
      it { expect(page).to have_link parent.name }
      it { expect(page).to have_content child.name }
      it { expect(page).to have_text 'used 1 time' }
      it { expect(page).not_to have_text 'Orphaned' }
    end
  end
end
