# frozen_string_literal: true

class VariablesController < ApplicationController
  before_action :set_variable, only: %i[show edit update destroy]
  def index
    @search = VariablesSearchService.new(params)
    @variables = @search.result.distinct(false).order(:name)
    @namespace_filter = @search.filter(:namespace)
  end

  def show; end

  private

  def set_variable
    @variable = Variable.find_by(name: params[:id])
  end

  def variable_params
    params.fetch(:variable, {})
  end
end
