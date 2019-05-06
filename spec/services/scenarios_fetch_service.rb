# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScenariosFetchService do
  let(:scenarios_total_number) { 5 }

  describe '.fetch_all' do
    subject { described_class.fetch_all }
    it 'adds all of the Scenarios to the database' do
      expect { subject }.to change { Scenario.count }
    end

    it 'removes stale Scenarios the database which are no longer part of the Data' do
      described_class.fetch_all
      stale_scenario, fresh_scenario = Scenario.all.sample(2)

      described_class.remove_stale_scenarios(scenario_names: [fresh_scenario.name])
      expect(Scenario.find_by(name: stale_scenario.name)).to be_nil
      expect(Scenario.find_by(name: fresh_scenario.name)).not_to be_nil
    end

    it { expect(described_class.git_clone_folder).to eq './tmp/test-openfisca-aotearoa' }

    it 'clones git repo' do
      FileUtils.rm_rf('./tmp/test-openfisca-aotearoa')
      expect(File).not_to exist('./tmp/test-openfisca-aotearoa')

      # clone
      described_class.clone_git_repo
      expect(File).to exist('./tmp/test-openfisca-aotearoa')
      # call again, and it'll only pull
      described_class.clone_git_repo
      expect(File).to exist('./tmp/test-openfisca-aotearoa')
    end
  end
end
