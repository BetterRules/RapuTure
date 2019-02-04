# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariablesController, type: :controller do
  describe '#index' do
    context 'one orphaned variable' do
      let!(:variable) { FactoryBot.create :variable }
      before { get :index, params: {} }
      it { expect(assigns(:link_from_counts)).to eq ({}) }
      it { expect(assigns(:link_to_counts)).to eq ({}) }
    end

    context 'three orphaned variables' do
      let!(:variable) { FactoryBot.create :variable }
      let!(:variable_two) { FactoryBot.create :variable }
      let!(:variable_three) { FactoryBot.create :variable }
      before { get :index, params: {} }
      it { expect(assigns(:link_from_counts)).to eq ({}) }
      it { expect(assigns(:link_to_counts)).to eq ({}) }
    end

    context 'two variables that refer to each other' do
      let!(:parent) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate', variables: [child] }
      let!(:child) { FactoryBot.create :variable, name: 'likes_to_eat' }
      before { get :index, params: {} }
      it { expect(assigns(:variables)).to eq [child, parent] }
      it { expect(assigns(:link_from_counts)).to eq ({ child.id => 1 }) }
      it { expect(assigns(:link_to_counts)).to eq ({ parent.id => 1 }) }
    end

    context 'Many variables that refer to each other' do
      let!(:parent_1) { FactoryBot.create :variable, name: 'likes_to_eat', variables: [child_1] }
      let!(:child_1) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate', variables: [grandchild_1] }
      let!(:grandchild_1){ FactoryBot.create :variable, name: 'likes_to_eat_chocolate_eggs' }

      let!(:parent_2) { FactoryBot.create :variable, name: 'likes_to_drink', variables: [child_2] }
      let!(:child_2) { FactoryBot.create :variable, name: 'likes_to_drink_water' }

      before { get :index, params: {} }

      # These appear in alphabetical order
      it { expect(assigns(:variables)).to eq [parent_2, child_2, parent_1, child_1, grandchild_1] }

      it { expect(assigns(:link_from_counts)).to eq ({ child_1.id => 1, child_2.id => 1, grandchild_1.id => 1 }) }
      it { expect(assigns(:link_to_counts)).to eq ({ parent_1.id => 1, parent_2.id => 1, child_1.id => 1 }) }
    end
  end
end
