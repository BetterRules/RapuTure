# frozen_string_literal: true


class EntitiesFetchService
  def self.fetch_all
    json_response = of_conn.get('entities').body
    json_response.keys.each do |name|
      spec = json_response[name]
      entity = Entity.find_or_initialize_by(name: name)
      entity.spec = spec
      entity.description = spec['description']
      entity.plural = spec['plural']
      entity.save!
      puts entity
    end
  end

  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
