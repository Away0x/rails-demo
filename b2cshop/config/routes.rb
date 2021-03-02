Rails.application.routes.draw do

  root 'welcome#index'

  get '/login', to: 'sessions#new', as: :login_form
  post '/login', to: 'sessions#create', as: :login
  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :users

  namespace :admin do
    root 'session#new'
    resources :categories
  end

end
