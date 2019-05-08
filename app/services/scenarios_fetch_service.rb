# frozen_string_literal: true

require 'yaml'
require 'find'

class ScenariosFetchService
  include Services

  def self.clone_or_pull_git_repo
    raise if clone_url.blank?

    if File.directory?(git_clone_folder)
      git_pull
    else
      git_clone
    end
  end

  def self.git_branch
    'master'
  end

  def self.git_pull
    Rails.logger.info("Pull branch #{git_branch}")
    g = Git.init(git_clone_folder)
    g.checkout(git_branch)
    g.pull
  end

  def self.git_clone
    Rails.logger.info("Cloning #{clone_url} into #{git_clone_folder}")
    g = Git.clone(clone_url, git_clone_folder)
    g.checkout(git_branch)
  end

  def self.git_clone_folder
    "./tmp/#{ENV['RAILS_ENV']}-openfisca-aotearoa"
  end

  def self.clone_url
    ENV['OPENFISCA_GIT_CLONE_URL']
  end

  def self.yaml_tests_folder
    "#{git_clone_folder}/openfisca_aotearoa/tests/"
  end

  def self.fetch_all
    clone_or_pull_git_repo
    found_scenarios = [] # Keep a running list of scenarios we found

    Find.find(yaml_tests_folder).each do |filename|
      next unless File.extname(filename) == '.yaml'

      Rails.logger.debug(filename)

      # https://github.com/ruby/psych/issues/262
      scenarios_list = YAML.load(File.read(filename)) # rubocop:disable Security/YAMLLoad
      scenario_names = scenarios_list.map { |s| s['name'] }
      found_scenarios += scenario_names
      Rails.logger.debug(scenario_names)
      Services.find_all_duplicates(scenario_names)
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

  def self.remove_stale_scenarios(scenario_names:)
    Scenario
      .where
      .not(name: scenario_names)
      .destroy_all
  end
end
