Rails.application.routes.draw do
  devise_for :owners
  devise_for :users
  root to: 'home#index'
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    get 'search', on: :collection
    resources :rooms, only: [:show, :new, :create, :edit, :update]
  end
end
