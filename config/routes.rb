Rails.application.routes.draw do
  resources :pitchers, only: [:index]
  resources :batters, only: [:index]
  devise_for :users
  root 'batters#index'
end
