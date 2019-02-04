# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariablesController, type: :controller do
  describe '#index' do

    context 'two variables that refer to each other' do
      let!(:parent) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate', variables: [child] }
      let!(:child) { FactoryBot.create :variable, name: 'likes_to_eat' }
      before { get :index, params: {} }
      it { expect(assigns(:variables)).to eq [child, parent] }
      it { expect(assigns(:link_from_counts)).to eq ({ child.id => 1 }) }
      it { expect(assigns(:link_to_counts)).to eq ({ parent.id => 1 }) }
    end

    context 'one orphaned variable' do
      let!(:variable) { FactoryBot.create :variable }
      before { get :index, params: {} }
      it { expect(assigns(:link_from_counts)).to eq ({ }) }
      it { expect(assigns(:link_to_counts)).to eq ({ }) }
    end
  end
end