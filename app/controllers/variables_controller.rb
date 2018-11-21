# frozen_string_literal: true

class VariablesController < ApplicationController
  before_action :set_variable, only: %i[show edit update destroy]
  def index
    @search = VariablesSearchService.new(params)
    @variables = @search.result.distinct(false).includes(:variables, :value_type).order(:name)
    @namespace_filter = @search.filter(:namespace)
  end

  def show
  end

  def calculate
    @query = {}
    Entity.all.each do |entity|
      @query[entity.plural] = {"named_#{entity.name}" => {}}
    end
    params.require(:answers).keys.each do |variable_name|
      variable = Variable.find_by(name: variable_name)
      @query[variable.entity.plural]["named_#{variable.entity.name}"][variable.name] = {}
    end
  end

  private

  def set_variable
    @variable = Variable.find_by(name: params[:id])
  end
end
