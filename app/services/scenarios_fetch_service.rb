# frozen_string_literal: true

require 'yaml'

class ScenariosFetchService
  def self.fetch_all
    example_file = '../openfisca-aotearoa/openfisca_aotearoa/tests/income_tax/family_scheme/best_start.yaml'
    # Needs to be updated to use github scraper

    # https://github.com/ruby/psych/issues/262
    scenarios_list = YAML.load(File.read(example_file)) # rubocop:disable Security/YAMLLoad

    scenario_names = scenarios_list.map { |s| s['name'] }

    find_all_duplicates(scenario_names)

    scenarios_list.each do |yaml_scenario|
      scenario = find_or_create_scenario(yaml_scenario)
      yield scenario if block_given?
    end

    remove_stale_scenarios(scenario_names: scenario_names)

    Scenario.all unless block_given?
  end

  def self.find_or_create_scenario(yaml_scenario)
    scenario = Scenario.find_or_initialize_by(name: yaml_scenario['name'])

    associated_variables = fetch_associated_variables(yaml_scenario['input'], yaml_scenario['output'])

    ActiveRecord::Base.transaction do
      scenario.inputs = yaml_scenario['input']
      scenario.outputs = yaml_scenario['output']
      scenario.period = yaml_scenario['period']
      scenario.error_margin = yaml_scenario['absolute_error_margin']
      scenario.save!
      scenario.variables << associated_variables
      # scenario.namespace = parse_namespace(yaml_scenario['name'])
      scenario
    end
  end

  def self.fetch_associated_variables(inputs, outputs)
    input_keys = get_all_keys(inputs)
    output_keys = get_all_keys(outputs)
    input_output_keys = input_keys + output_keys

    Variable.select('id').where(name: input_output_keys)
  end

  # https://gist.github.com/naveed-ahmad/8f0b926ffccf5fbd206a1cc58ce9743e
  def self.find_all_duplicates(array)
    map = {}
    dup = []
    array.each do |v|
      map[v] = (map[v] || 0) + 1

      dup << v if map[v] == 2
    end
    raise StandardError.new("These scenarios have duplicate names: #{dup} !!!!!") if dup[0]
  end

  def self.remove_stale_scenarios(scenario_names:)
    Scenario
      .where
      .not(name: scenario_names)
      .destroy_all
  end

  # Needs to be updated to use github scraper
  def self.scrapped_data
    # Faraday.new ENV['OPENFISCA_URL'] do |conn|
    #   conn.response :json, content_type: /\bjson$/
    #   conn.adapter Faraday.default_adapter
    # end
  end

  # This could use some refinement
  # Currently it is returning all the keys
  # Can't just user lower level though because of data structures like:
  #  output:
  #   best_start__tax_credit_per_child:
  #     2018-07: [0, 0, 0, 260 ]

  def self.get_all_keys(hash)
    hash.each_with_object([]) do |(k, v), keys|
      keys << k
      keys.concat(get_all_keys(v)) if v.is_a? Hash
    end
  end
end
