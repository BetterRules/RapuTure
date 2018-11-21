# frozen_string_literal: true

class VariablesFetchService
  def self.fetch_all
    json_response = of_conn.get('variables').body
    ActiveRecord::Base.transaction do
      json_response.keys.each do |name|
        variable = Variable.find_or_initialize_by(name: name)
        fetch(variable)
      end
    end
  end

  def self.fetch(variable)
    spec = of_conn.get("variable/#{variable.name}").body
    ActiveRecord::Base.transaction do
      variable.update!(
        spec: spec,
        href: spec['href'],
        description: spec['description'],
        value_type: ValueType.find_or_create_by(name: spec['valueType']),
        namespace: parse_namespace(variable.name)
      )

      # variable.variables.clear

      if variable.has_formula?
        variable.spec['formulas'].each do |_d, formula|
          Variable.all.each do |v|
            # Is this variable refences
            if formula['content'].include?("'#{v.name}'") || formula['content'].include?("\"#{v.name}\"")
              # Add it to .variables, if it's not there
              variable.variables << v unless variable.variables.include? v
            else
              # remove it from from .varibles if it's there
              variable.variables.delete(v) if variable.variables.include? v
            end
          end
        end
      end
    end
  end

  def self.parse_namespace(name)
    name.split('__')[0] if name.include? '__'
  end

  def self.of_conn
    Faraday.new ENV['OPENFISCA_URL'] do |conn|
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
