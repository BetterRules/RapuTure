# frozen_string_literal: true
require 'yaml'

class ScenariosFetchService
    def self.fetch_all
    # Needs to be updated to use github scraper
    scenarios_list = YAML.load(File.read("../openfisca-aotearoa/openfisca_aotearoa/tests/income_tax/family_scheme/best_start.yaml"))

    scenario_names = scenarios_list.map { |s| s["name"] }

    find_all_duplicates(scenario_names)
    
    scenarios_list.each do |yaml_scenario|
      scene = find_or_create_scenario(yaml_scenario)
      yield scene if block_given?
    end

    remove_stale_scenarios(scenario_names: scenario_names)
    
    Scenario.all unless block_given?
  end

  def self.find_or_create_scenario(yaml_scenario)
    
    scenario = Scenario.find_or_initialize_by(name: yaml_scenario['name'])

    associate_variables_and_scenarios(scenarios_list)

    ActiveRecord::Base.transaction do
      scenario.inputs = yaml_scenario['input']
      scenario.outputs = yaml_scenario['output']
      scenario.period = yaml_scenario['period']
      scenario.error_margin = yaml_scenario['absolute_error_margin']
      # scenario.namespace = parse_namespace(yaml_scenario['name'])
      scenario.save!
      scenario
    end
  end

  # https://gist.github.com/naveed-ahmad/8f0b926ffccf5fbd206a1cc58ce9743e
  def self.find_all_duplicates(array)
    map = {}
    dup = []
    array.each do |v|
      map[v] = (map[v] || 0 ) + 1
  
      if map[v] == 2
        dup << v
      end
    end
    raise StandardError.new("These scenarios have duplicate names: #{dups} !!!!!") if dup[0]
  end

  def associate_variables_and_scenarios (scenario)
    
  end


  def self.remove_stale_scenarios(scenario_names:)
    Scenario
      .where
      .not(name: scenario_names)
      .delete_all
  end

  # Needs to be updated to use github scraper
  def self.scrapped_data
    # Faraday.new ENV['OPENFISCA_URL'] do |conn|
    #   conn.response :json, content_type: /\bjson$/
    #   conn.adapter Faraday.default_adapter
    end
  end
end
