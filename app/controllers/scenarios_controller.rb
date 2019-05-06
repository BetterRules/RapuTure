# frozen_string_literal: true

class ScenariosController < ApplicationController
  def index
    @scenarios = Scenario.all.order(:name)
  end

  def show
    @scenario = Scenario.find(params[:id])
    @variables = @scenario.variables.uniq
  end
end
