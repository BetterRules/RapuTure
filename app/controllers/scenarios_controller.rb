# frozen_string_literal: true

class ScenariosController < ApplicationController
  def index
    if params[:variable_id].present?
      @variable = Variable.find_by(name: params[:variable_id])
      @scenarios = @variable.output_scenarios
    else
      @scenarios = Scenario.all.order(:name)
    end
  end

  def show
    @scenario = Scenario.find(params[:id])
  end
end
