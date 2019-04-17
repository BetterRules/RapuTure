# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScenariosFetchService do
  let(:scenarios_total_number) { 5 }

  let(:scenarios) do
    FactoryBot.build_list(:scenario, scenarios_total_number)
  end

  describe '.fetch_all' do
    it 'adds all of the Scenarios to the database' do
      expect { described_class.fetch_all }.to change { Scenario.count }.by(scenarios_total_number)
    end

    xit 'removes stale Scenarios the database which are no longer part of the Data' do
      described_class.fetch_all
      stale_scenario, fresh_scenario = scenarios.sample(2)
      scenarios.delete(stale_scenario.name)
      described_class.fetch_all
      expect(Scenario.find_by(name: stale_scenario.name)).to be_nil
      expect(Scenario.find_by(name: fresh_scenario.name)).not_to be_nil
    end

    xit 'deletes join table records when deleted' do
    end
  end
end
