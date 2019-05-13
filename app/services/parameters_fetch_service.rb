# frozen_string_literal: true

class ParametersFetchService
  include Services

  def self.git_clone_folder
    "./tmp/#{ENV['RAILS_ENV']}-openfisca-aotearoa"
  end

  def self.yaml_tests_folder
    "#{git_clone_folder}/openfisca_aotearoa/parameters/"
  end

  def self.fetch_all
    found_parameters = [] # Keep a running list of parameters we found

    Find.find(yaml_tests_folder).each do |filename|
      next unless File.extname(filename) == '.yaml'

      # https://github.com/ruby/psych/issues/262
      parameters_list = YAML.load(File.read(filename)) # rubocop:disable Security/YAMLLoad
      parameters_list['filename'] = filename

      found_parameters.push(parameters_list['filename'])
      find_or_create_parameter(parameters_list)
    end

    remove_stale_parameters(found_parameters)
  end

  def self.remove_stale_parameters(parameter_names)
    Parameter
      .where
      .not(filename: parameter_names)
      .delete_all
  end

  def self.find_or_create_parameter(yaml_parameter)
    parameter_name = yaml_parameter['filename']
    raise if parameter_name.blank?

    parameter = Parameter.find_or_initialize_by(filename: parameter_name)

    ActiveRecord::Base.transaction do
      parameter.description = yaml_parameter['description']
      parameter.href = yaml_parameter['reference']
      parameter.brackets = yaml_parameter['brackets'] || ''
      parameter.filename = yaml_parameter['filename']
      parameter.values = yaml_parameter['values'] || ''
      parameter.save!
      parameter
    end
  end
end
