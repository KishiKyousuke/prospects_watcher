# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:edit, :update] do
    get :favorite_batters, on: :collection
    get :favorite_pitchers, on: :collection
  end
  resources :players, only: :index
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :players, only: [:index]
      resources :favorite_pitchers, only: [:create, :destroy]
      resources :favorite_batters, only: [:create, :destroy]
    end
  end
  resources :registered_players, only: :index
  root 'registered_players#index'
end
