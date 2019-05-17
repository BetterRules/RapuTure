# frozen_string_literal: true

require 'yaml'
require 'find'

class ScenariosFetchService < GithubCloneService

  def self.fetch_all
    clone_or_pull_git_repo
    found_scenarios = [] # Keep a running list of scenarios we found

    Find.find(yaml_folder('tests')).each do |filename|
      next unless File.extname(filename) == '.yaml'

      Rails.logger.debug(filename)

      # https://github.com/ruby/psych/issues/262
      scenarios_list = YAML.load(File.read(filename))
      scenario_names = scenarios_list.map { |s| s['name'] }
      found_scenarios += scenario_names
      Rails.logger.debug(scenario_names)
      find_all_duplicates(scenario_names)
      scenarios_list.each do |yaml_scenario|
        find_or_create_scenario(yaml_scenario)
      end
    end

    remove_stale_scenarios(scenario_names: found_scenarios)
  end

  def self.find_or_create_scenario(yaml_scenario)
    scenario_name = yaml_scenario['name']
    raise if scenario_name.blank?

    scenario = Scenario.find_or_initialize_by(name: scenario_name)

    ActiveRecord::Base.transaction do
      scenario.inputs = yaml_scenario['input']
      scenario.outputs = yaml_scenario['output']
      scenario.period = yaml_scenario['period']
      scenario.error_margin = yaml_scenario['absolute_error_margin']
      scenario.save!
      scenario.parse_variables!
      scenario
    end
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
end
