Rails.application.routes.draw do

  root 'home#index'

  resource :session, only: [:new, :create, :destroy]
  resources :users, except: [:show]

  resources :artists, only: [:index, :show, :edit, :update]
  resources :albums, only: [:index, :show, :edit, :update]
  resources :songs, only: [:index, :show]

  get '/403', to: 'errors#forbidden', as: :forbidden
  get '/404', to: 'errors#not_found', as: :not_found
  get '/422', to: 'errors#unprocessable_entity', as: :unprocessable_entity
  get '/500', to: 'errors#internal_server_error', as: :internal_server_error
end
