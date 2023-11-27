Rails.application.routes.draw do
  devise_for :owners
  devise_for :users
  
  root to: 'home#index'
  get 'cities', to: 'home#cities'

  resources :inns, only: [:show, :new, :create, :edit, :update] do
    resources :rooms, only: [:show, :new, :create, :edit, :update]
    get 'search', on: :collection
  end
  resources :rooms do
    resources :custom_prices, only: [:new, :create, :destroy]
    resources :reservations, only: [:new, :create] do
      get 'check', on: :collection
    end
  end
  resources :reservations, only: [:index, :show] do
    post 'cancel', on: :member
    post 'checkin', on: :member
    post 'checkout', on: :member
    post 'finish', on: :member
  end

  get 'active_stays', to: 'reservations#active_stays'

  resources :user_reservations, only: [:index] do
    post 'cancel', on: :member
  end
end
