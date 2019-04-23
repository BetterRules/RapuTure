# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScenariosFetchService do
  let(:scenarios_total_number) { 5 }

  describe '.fetch_all' do
    it 'adds all of the Scenarios to the database' do
      expect { described_class.fetch_all }.to change { Scenario.count }.by(scenarios_total_number)
    end

    it 'removes stale Scenarios the database which are no longer part of the Data' do
      described_class.fetch_all
      stale_scenario, fresh_scenario = Scenario.all.sample(2)

      described_class.remove_stale_scenarios(scenario_names: [fresh_scenario.name])
      expect(Scenario.find_by(name: stale_scenario.name)).to be_nil
      expect(Scenario.find_by(name: fresh_scenario.name)).not_to be_nil
    end

    xit 'deletes join table records when deleted' do
    end
  end
end
