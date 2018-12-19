# frozen_string_literal: true

class EntitiesFetchService
  def self.fetch_all
    json_response = of_conn.get('entities').body
    json_response.keys.each do |name|
      entity_json = json_response.fetch(name, {})
      entity = Entity.find_or_initialize_by(name: name)

      entity.description = entity_json['description']
      entity.plural = entity_json['plural']
      entity.documentation = entity_json['documentation']
      entity.save!

      entity_json.fetch('roles', []).each do |name, role_json|
        role = Role.find_or_initialize_by(name: name, entity: entity)
        role.description = role_json.fetch('description')
        role.max = role_json.fetch('max', nil)
        role.plural = role_json.fetch('plural')
        role.save!
      end
    end
  end

  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
