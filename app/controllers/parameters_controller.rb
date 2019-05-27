# frozen_string_literal: true

class ParametersController < ApplicationController
  def index
    @parameters = Parameter.all.order(:filename)
  end

  def show
    @parameter = Parameter.find(params[:id])
    @filename = @parameter.filename
    @brackets = @parameter.brackets unless @parameter.brackets.empty?
    @values = @parameter.values unless @parameter.values.empty?
  end
end
