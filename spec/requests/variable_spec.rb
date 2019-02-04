# frozen_string_literal: true

require 'rails_helper'
require 'faker'
RSpec.describe Variable, type: :request do
  let(:sentence) do
    Faker::Lorem.sentence
  end

  let(:url) do
    Faker::Internet.url
  end

  it 'renders nothing if the variable has no references' do
    variable = FactoryBot.create(:variable, references: [])
    name = variable.name

    get "/variables/#{name}"
    expect(response.body).not_to include('Source:')
    expect(response.body).not_to include('Reference')
  end

  it "renders a reference which is not just a url as 'Source: ref'" do
    variable = FactoryBot.create(:variable, references: [sentence])
    name = variable.name

    get "/variables/#{name}"
    expect(response.body).to include('Source:')
  end

  it "renders a reference is just a url as a link which says 'Reference" do
    variable = FactoryBot.create(:variable, references: [url])
    name = variable.name

    get "/variables/#{name}"
    expect(response.body).to include('Reference')
  end
end
