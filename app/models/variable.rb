# frozen_string_literal: true

class Variable < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_and_belongs_to_many(:variables,
    class_name: 'Variable',
    join_table: "links",
    foreign_key: "link_to",
    association_foreign_key: "link_from")

  has_and_belongs_to_many(:reversed_variables,
    class_name: 'Variable',
    join_table: "links",
    foreign_key: "link_from",
    association_foreign_key: "link_to")

  def has_formula?
    return spec['formulas'].present?
  end

  def fetch_all!
    json_response = of_conn.get('variables')
    ActiveRecord::Base.transaction do
      Variable.delete_all
      json_response.body.keys.each do |name|
        v = Variable.find_or_create_by(name: name, href: json_response.body[name]['href'])
        v.update(description: json_response.body[name]['description'])
      end
    end
  end

  def fetch!
    json_response = of_conn.get("variable/#{name}")
    update!(spec: json_response.body)

    ActiveRecord::Base.transaction do
      variables.clear

      if has_formula?
        spec['formulas'].each do |d, formula|
          Variable.all.each do |v|
            variables << v if formula['content'].include?("'#{v.name}'") || formula['content'].include?("\"#{v.name}\"")
          end
        end
      end
    end
  end

  def of_conn
    Faraday.new 'http://api.rules.nz/' do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
