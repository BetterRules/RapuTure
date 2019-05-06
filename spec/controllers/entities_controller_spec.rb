# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EntitiesController, type: :controller do
  describe '#index' do
    let!(:entities) { FactoryBot.create_list :entity, 3 }
    before { get :index }
    it { expect(assigns(:entities)).to include entities[0] }
    it { expect(assigns(:entities)).to include entities[1] }
    it { expect(assigns(:entities)).to include entities[2] }
  end
  describe '#show' do
    let(:entity) { FactoryBot.create :entity }
    before { get :show, params: { id: entity.to_param } }
    it { expect(assigns(:entity)).to eq entity }
  end
end
