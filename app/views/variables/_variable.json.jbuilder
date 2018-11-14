# frozen_string_literal: true

json.extract! variable, :id, :created_at, :updated_at
json.url variable_url(variable, format: :json)
