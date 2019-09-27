# frozen_string_literal: true

require 'rails_helper'

describe 'index' do
  let(:brackets_hash) do
    {
      'rate' => { '2018-04-01' => { 'value' => 3351 } },
      'threshold' => { '2018-04-01' => { 'value' => 0 } }
    }
  end
  let(:values_hash) do
    { '1977-12' => { 'value' => 16 } }
  end
  let(:our_parameters) do
    scen = FactoryBot.create :parameter, description: 'a complicated situation',
                                         href: 'http://areallylongurl.com',
                                         brackets: brackets_hash,
                                         values: values_hash,
                                         filename: 'minimum_age_threshold.yaml'
    scen
  end
  describe 'view all parameters' do
    before { visit parameter_path(our_parameters) }
    it { expect(page).to have_content 'Brackets' }
    it { expect(page).to have_content '1977-12' }
  end
end
