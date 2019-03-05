require 'simulations_service.rb'

class SimulationsController < ApplicationController

  def show
    @simulation = Simulation.find(params[:id])
  end
  
  def new
    @variable = Variable.find_by name: params[:variable]
  end

  def create
    @variable = Variable.find_by name: params[:variable]
    @query = query_from_params
    @resonse = SimluationsService.calculate(@query)
    @simulation = Simulation.create!(variable: @variable, request: @query, response: @resonse)
    respond_with @simulation
  end

  def query_from_params
    period = params[:period]
    query = {'persons' => {}, 'families'=> {}, 'titled_properties'=> {}}
    people = params.require(:persons).keys

    people.each do |person_name|
      variables = params.require(:persons).require(person_name).keys
      values = params.require(:persons).require(person_name).permit(variables).to_hash
      query['persons'][person_name] = {}
      values.each do |variable_name, value|
        variable = Variable.find_by name: variable_name
        value = (value=='1') if variable.value_type.name == 'Boolean'
        value = value.to_i if variable.value_type.name == 'Int'
        # input variables
        query['persons'][person_name][variable_name] = {period => value}
      end

      # output variables
      query['persons'][person_name][@variable.name] = {period => nil}

    end

    query['families']['family_one'] = {'others'=> people}
    query['titled_properties']['whare_one'] = {'others' => people}
    query
  end
end
