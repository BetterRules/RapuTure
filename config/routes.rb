# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'variables#index'
  resources :variables, only: %i[show index]
  post 'variables/calculate', to: 'variables#calculate'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
