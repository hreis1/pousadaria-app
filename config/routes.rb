Rails.application.routes.draw do
  devise_for :owners
  devise_for :users
  
  root to: 'home#index'
  get 'cities', to: 'home#cities'

  resources :inns, only: [:show, :new, :create, :edit, :update] do
    get 'search', on: :collection
    resources :rooms, only: [:show, :new, :create, :edit, :update] do
      resources :custom_prices, only: [:new, :create, :destroy]
    end
  end
  resources :rooms do
    resources :reservations, only: [:new, :create] do
      get 'check_availability', on: :collection
      get 'confirm', on: :collection
    end
  end
end
