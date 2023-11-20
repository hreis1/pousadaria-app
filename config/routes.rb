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
    end
  end
  get 'owner_reservations', to: 'reservations#owner_reservations'
  get 'owner_reservations/:id', to: 'reservations#owner_reservation', as: :owner_reservation
  post 'owner_reservations/:id/checkin', to: 'reservations#checkin', as: :checkin
  get 'active_stays', to: 'reservations#active_stays'

  get 'my_reservations', to: 'reservations#my_reservations'
  post 'cancel_reservation/:id', to: 'reservations#cancel_reservation', as: :cancel_reservation
end
