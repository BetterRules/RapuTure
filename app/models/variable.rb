# frozen_string_literal: true

class Variable < ApplicationRecord
  def fetch_all!
    json_response = of_conn.get('variables')

    ActiveRecord::Base.transaction do
      json_response.body.keys.each do |name|
        v = Variable.find_or_create_by(name: name, href: json_response.body[name]['href'])
        v.update(description: json_response.body[name]['description'])
      end
    end
  end

  def fetch!
    json_response = of_conn.get("variable/#{name}")
    update!(spec: json_response.body)
  end

  def of_conn
    Faraday.new 'http://api.rules.nz/' do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
