# frozen_string_literal: true

class ParametersFetchService
  def self.fetch_all
    parameters_list = of_conn.get('parameters').body
    parameters_list.each do |name, attributes|
      p = find_or_create_parameter(parameter_name: name, parameter_attributes: attributes)
      yield p if block_given?
    end

    remove_stale_parameters(parameter_names: parameters_list.keys)

    Parameter.all unless block_given?
  end

  def self.find_or_create_parameter(parameter_name:, parameter_attributes: {})
    parameter = Parameter.find_or_initialize_by(name: parameter_name)
    parameter.update(parameter_attributes)

    fetch(parameter)
  end

  def self.remove_stale_parameters(parameter_names:)
    Parameter
      .where
      .not(name: parameter_names)
      .delete_all
  end

  def self.fetch(parameter)
    json_res = parameter(name: parameter.name)
    ActiveRecord::Base.transaction do
      parameter.source = json_res['source']
      parameter.brackets = json_res['brackets']
      parameter.metadata = json_res['metadata']
      parameter.values = json_res['values']
      parameter.save!
      parameter
    end
  end

  def self.parameter(name:)
    of_conn.get("parameter/#{CGI.escape(name)}").body
  end

  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
