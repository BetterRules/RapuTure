# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScenariosController, type: :controller do
  describe '#index' do
    let!(:scenarios) { FactoryBot.create_list :scenario, 3 }
    before { get :index }
    it { expect(assigns(:scenarios)).to include scenarios[0] }
    it { expect(assigns(:scenarios)).to include scenarios[1] }
    it { expect(assigns(:scenarios)).to include scenarios[2] }
  end
  describe '#show' do
    let(:scenario) { FactoryBot.create :scenario }
    before { get :show, params: { id: scenario.to_param } }
    it { expect(assigns(:scenario)).to eq scenario }
  end
end
