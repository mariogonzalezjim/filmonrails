require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  root 'home#index'
  get 'new', to: 'home#new' 
  post 'new', to: 'home#create'
  post 'login', to: 'home#login'
  get 'dashboard', to: 'home#dashboard'
  get 'logout', to: 'home#logout'
  post 'search_film', to:'home#search_film'
  post 'search_film_year', to:'home#search_film_year'
  get 'search', to: 'home#search'
  get 'description', to: 'home#description'
  get 'historical', to: 'home#historical'
  mount Sidekiq::Web => '/sidekiq'
end
