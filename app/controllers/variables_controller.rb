# frozen_string_literal: true

class VariablesController < ApplicationController
  before_action :set_variable, only: %i[show edit update destroy]

  def index
    @search = VariablesSearchService.new(params)

    @variables = @search.result
                        .distinct(false)
                        .includes(:variables, :value_type, :entity)
                        .order(:name)

    # Get the links between variables (both directions)
    # in just 2 quick db queries
    @link_from_counts = link_count(:variables, :link_from)
    @link_to_counts = link_count(:reversed_variables, :link_to)

    @namespace_filter = @search.filter(:namespace)
  end

  def show; end

  private

  def link_count(relationship, column)
    Variable.all.joins(relationship).group(column).count
  end

  def set_variable
    @variable = Variable.find_by(name: params[:id])
  end
end
