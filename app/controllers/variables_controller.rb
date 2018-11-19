# frozen_string_literal: true

class VariablesController < ApplicationController
  before_action :set_variable, only: %i[show edit update destroy]

  class VariableSearch < FortyFacets::FacetSearch
    model 'Variable' # which model to search for
    text :name # filter by a generic string entered by the user
    # scope :classics   # only return movies which are in the scope 'classics'
    # range :price, name: 'Price' # filter by ranges for decimal fields
    facet :namespace, name: 'Namespace' # , order: :year # additionally order values in the year field
    # facet :studio, name: 'Studio', order: :name
    # facet :genres, name: 'Genre' # generate a filter with all values of 'genre' occuring in the result
    # facet [:studio, :country], name: 'Country' # generate a filter several belongs_to 'hops' away
    # orders 'Name' => :name
  end

  def index
    @search = VariableSearch.new(params)
    @variables = @search.result.distinct(false).order(:name)
    @filters = @search.filter(:namespace)
  end

  def show; end

  def new
    @variable = Variable.new
  end

  def edit; end

  def create
    @variable = Variable.new(variable_params)

    respond_to do |format|
      if @variable.save
        format.html { redirect_to @variable, notice: 'Variable was successfully created.' }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to @variable, notice: 'Variable was successfully updated.' }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to variables_url, notice: 'Variable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_variable
    @variable = Variable.find_by(name: params[:id])
  end

  def variable_params
    params.fetch(:variable, {})
  end
end
