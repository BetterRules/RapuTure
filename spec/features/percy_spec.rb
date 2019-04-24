# frozen_string_literal: true

require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  it 'loads example.com homepage' do
    visit root_path
    Percy.snapshot(page)
  end
end
