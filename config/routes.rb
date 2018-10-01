Rails.application.routes.draw do
  resources :memberships
  get 'signup', to: 'users#new'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  resources :users
  resources :beers
  resources :breweries
  resources :beer_clubs
  root 'breweries#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
end
