# frozen_string_literal: true

require 'rails_helper'

describe 'index' do
  before do
    FactoryBot.create :parameter,
                      description: 'a complicated situation',
                      href: 'http://areallylongurl.com',
                      brackets: {
                        'rate' => { '2018-04-01' => { 'value' => 3351 } }, 'threshold' => { '2018-04-01' => { 'value' => 0 } }
                      },
                      values: { '1977-12' => { 'value' => 16 } },
                      filename: 'minimum_age_threshold.yaml'
  end
  describe 'view all parameters' do
    before { visit parameters_path }
    it { expect(page).to have_content 'Minimum Age Threshold' }
  end
end
