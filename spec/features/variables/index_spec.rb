# frozen_string_literal: true

require 'rails_helper'

feature 'index' do
  context 'Variable not refered to' do
    before { FactoryBot.create :variable, name: 'likes_to_eat_chocolate' }
    describe 'view all variables' do
      before { visit variables_path }
      it { expect(page).to have_text 'Available filters for Namespace' }
      it { expect(page).to have_link 'likes_to_eat_chocolate' }
      it { expect(page).to have_text 'used 0 times' }
      it { expect(page).to have_text 'Orphaned' }
    end
  end

  context 'Variable refers to others' do
    before do
      parent = FactoryBot.create :variable, name: 'likes_to_eat_chocolate'
      child = FactoryBot.create :variable, name: 'likes_to_eat'
      parent.variables << child
    end
    describe 'view all variables' do
      before { visit variables_path }
      it { expect(page).to have_link 'likes_to_eat_chocolate' }
      it { expect(page).to have_link 'likes_to_eat' }
      it { expect(page).not_to have_text 'Orphaned' }
      it { expect(page).to have_text 'used 1 time' }
    end
  end
end
