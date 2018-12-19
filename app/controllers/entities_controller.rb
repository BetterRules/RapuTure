# frozen_string_literal: true

class EntitiesController < ApplicationController
  def index
    @entities = Entity.all.includes(:variables).order(:name)
  end

  def show
    @entity = Entity.find_by(name: params[:id])
  end
end
