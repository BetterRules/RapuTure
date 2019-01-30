# frozen_string_literal: true

class PagesController < ActionController::Base
  def show
    render 'about'
  end
end
