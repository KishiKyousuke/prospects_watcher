# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :pitchers, only: [] do
    resource :favorite_pitchers, only: [:create, :destroy]
  end
  resources :batters, only: [] do
    resource :favorite_batters, only: [:create, :destroy]
  end
  resources :users, only: [:edit, :update] do
    get :favorite_batters, on: :collection
    get :favorite_pitchers, on: :collection
  end
  resources :players, only: :index
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :players, only: [:index]
    end
  end
  resources :registered_players, only: :index
  root 'registered_players#index'
end
