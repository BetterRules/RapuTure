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
    result = {}
    variables.map do |vari|
      result[vari[:name]] = vari.slice(:description, :href)
    end
    result
  end

  # Mock responses from the OpenFisca server using our dummy data If the
  # production server starts returning unexpected responses you can remove this
  # mock and the tests will run against the production data, which might help
  # diagnose an API change in OpenFisca
  before do
    allow_any_instance_of(Faraday::Connection).to receive(:get) do |_self, param|
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
    it 'adds all of the Variables to the database' do
      expect { described_class.fetch_all }.to change(Variable, :count).by(variables_total_number)
    end

    it 'removes stale Variables the database which are no longer part of API' do
      described_class.fetch_all
      stale_variable, fresh_variable = variables.sample(2)
      variables_body.delete(stale_variable.name)
      described_class.fetch_all
      expect(Variable.find_by(name: stale_variable.name)).to be_nil
      expect(Variable.find_by(name: fresh_variable.name)).not_to be_nil
    end

    xit 'unlinks linked variables when one is deleted' do
    end

    it 'streams Variable objects if a block is given' do
      described_class.fetch_all { |v| expect(v).to be_a Variable }
    end

    it 'returns a collection of Variable objects if no block is given' do
      results = described_class.fetch_all
      results.each { |v| expect(v).to be_a Variable }
    end

    it 'correctly sets the href and description attributes' do
      # There used to be a bug where an available href value would be
      # overwritten by nil during the .fetch call. This could also have applied
      # to the description (since they are retrieved in the first variables_list
      # call). This is a regression test to ensure the values aren't lost again
      # in future if the server responses or our code change.
      #
      # Note that this test isn't very useful if the OpenFisca responses are
      # mocked above. Consider running this against the live server to debug
      # weird server behaviour.

      # Pick a random Variable where href and description are set
      variable = variables.select { |v| v.href.present? && v.description.present? }.sample

      # Load all the variables, which should correctly set href and description
      described_class.fetch_all

      # Find the corresponding Variable model in the database
      model = Variable.find_by(name: variable.name)
      expect(model).not_to be_nil

      # Check that the database has recorded the correct values from the original data
      expect(model.href).to eq variable.href
      expect(model.description).to eq variable.description
    end
  end

  describe '.fetch' do
    let(:new_variable) { Variable.new(variables.sample.slice(:name)) }

    subject { described_class.fetch(new_variable) }

    it 'retrieves a variable with the expected attributes' do
      pending 'dummy data needs to be updated'

      expect(subject.attributes.keys).to match_array(
        %w[id name href references spec created_at updated_at namespace
           value_type_id entity_id unit description]
      )
      expect(subject.spec.keys).to match_array(
        %w[defaultValue definitionPeriod description entity id references
           source valueType]
      )
    end

    it 'loads the example variable into the database' do
      expect { subject }.to change(Variable, :count).by(1)
      expect(Variable.find_by(name: new_variable.name)).not_to be_nil
    end
  end

  describe '.variable' do
    subject { described_class.variable(name: variables.sample.name) }

    it 'retrieves a variable with the expected attributes' do
      pending 'dummy data needs to be updated'
      expect(subject.keys).to match_array(
        %w[defaultValue definitionPeriod description entity id references
           source valueType]
      )
    end
  end
end
