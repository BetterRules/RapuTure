# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariablesFetchService do
  # The count of variables on the live server is about 220
  let(:variables_total_number) { 10 }

  let(:variables) do
    FactoryBot.build_list(:variable, variables_total_number)
  end

  let(:variables_dictionary) do
    variables
      .index_by(&:name)
      .transform_values(&:attributes)
  end

  let(:variables_body) do
    variables.map do |vari|
      [vari[:name], vari.slice(:description, :href)]
    end
  end

  # Mock responses from the OpenFisca server using our dummy data If the
  # production server starts returning unexpected responses you can remove this
  # mock and the tests will run against the production data, which might help
  # diagnose an API change in OpenFisca
  before do
    allow_any_instance_of(Faraday::Connection)
      .to receive(:get) do |_self, param|
        if param == 'variables'
          OpenStruct.new(body: variables_body)
        else
          # 'variable/variable_name'
          name = param.split('/').second
          OpenStruct.new(body: variables_dictionary[name])
        end
      end
  end

  describe '.fetch_all' do
    subject { described_class.fetch_all }

    it 'adds all of the Variables to the database' do
      expect { subject }.to change { Variable.count }.by(variables_total_number)
    end
  end

  describe '.fetch' do
    let(:new_variable) { Variable.new(variables.sample.slice(:name)) }

    subject { described_class.fetch(new_variable) }

    it 'retrieves a variable with the expected attributes' do
      pending 'dummy data needs to be updated'

      expect(subject.attributes.keys).to match_array(
        %w[id name href references spec created_at updated_at namespace value_type_id entity_id unit description]
      )
      expect(subject.spec.keys).to match_array(
        %w[defaultValue definitionPeriod description entity id references source valueType]
      )
    end

    it 'loads the example variable into the database' do
      expect { subject }.to change { Variable.count }.by(1)
      expect(Variable.find_by(name: new_variable.name)).not_to be_nil
    end
  end

  describe '.variables_list' do
    subject { described_class.variables_list }

    it 'fetches all the variable descriptions' do
      expect(subject.count).to eq variables_total_number
    end
  end

  describe '.variable' do
    subject { described_class.variable(name: variables.sample.name) }

    it 'retrieves a variable with the expected attributes' do
      pending 'dummy data needs to be updated'
      expect(subject.keys).to match_array(
        %w[defaultValue definitionPeriod description entity id references source valueType]
      )
    end
  end
end
