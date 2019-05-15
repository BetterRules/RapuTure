# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParametersController, type: :controller do
  describe '#index' do
    let!(:parameters) { FactoryBot.create_list :parameter, 3 }
    before { get :index }
    it { expect(assigns(:parameters)).to include parameters[0] }
    it { expect(assigns(:parameters)).to include parameters[1] }
    it { expect(assigns(:parameters)).to include parameters[2] }
  end
  describe '#show' do
    let(:parameter) { FactoryBot.create :parameter }
    before { get :show, params: { id: parameter.to_param } }
    it { expect(assigns(:parameter)).to eq parameter }
  end
end
