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
      resource :favorite_pitchers, only: [:create, :destroy]
      resource :favorite_batters, only: [:create, :destroy]
      resources :registered_players, only: [:index]
    end
  end
  resources :registered_players, only: :index
  root 'registered_players#index'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
