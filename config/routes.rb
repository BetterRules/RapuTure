# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'entities#index'
  resources :entities, only: %i[show index]
  resources :variables, only: %i[show index]
  resources :scenarios, only: %i[show index]
  # get "/:page" => "pages#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
