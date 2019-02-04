# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariablesController, type: :controller do
  let!(:parent) { FactoryBot.create :variable, name: 'likes_to_eat_chocolate', variables: [child] }
  let!(:child) { FactoryBot.create :variable, name: 'likes_to_eat' }
  describe '#index' do
    before { get :index, params: {} }
    it { expect(assigns(:variables)).to eq [child, parent] }
    it { expect(assigns(:link_from_counts)).to eq ({ child.id => 1 }) }
    it { expect(assigns(:link_to_counts)).to eq ({ parent.id => 1 }) }
  end
end
