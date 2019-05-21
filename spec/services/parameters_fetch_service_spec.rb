# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParametersFetchService do
  let(:parameters_total_number) { 5 }

  describe '.fetch_all' do
    subject { described_class.fetch_all }
    it 'adds all of the Parameters to the database' do
      expect { subject }.to change(Parameter, :count)
    end

    it 'removes stale Parameters the database which are no longer part of the Data' do
      described_class.fetch_all
      stale_parameter, fresh_parameter = Parameter.all.sample(2)

      described_class.remove_stale_parameters([fresh_parameter.filename])
      expect(Parameter.find_by(filename: stale_parameter.filename)).to be_nil
      expect(Parameter.find_by(filename: fresh_parameter.filename)).not_to be_nil
    end

    it { expect(described_class.git_clone_folder).to eq './tmp/test-openfisca-aotearoa' }
    it { expect(described_class.yaml_folder('parameters')).to eq './tmp/test-openfisca-aotearoa/openfisca_aotearoa/parameters/' }
  end
end
