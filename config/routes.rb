Rails.application.routes.draw do
  devise_for :owners
  devise_for :users
  root to: 'home#index'
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    resources :rooms, only: [:show, :new, :create]
  end
  get 'my_inn', to: 'inns#my_inn'
  
end
