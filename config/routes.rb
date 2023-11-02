Rails.application.routes.draw do
  devise_for :owners
  devise_for :users
  root to: 'home#index'
  resources :inns, only: [:show, :new, :create]
  
end
