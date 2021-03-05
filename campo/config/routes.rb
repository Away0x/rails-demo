Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'home#index'

  get '/sign_up', to: 'users#new', as: :sign_up
  resources :users, only: [:create] do
    collection do
      post 'validate/:attribute', to: 'users#validate', constraints: { attribute: /name|username|email|password/ }
    end
  end

  resource :session, only: [:create]
  get '/sign_in', to: 'sessions#new', as: :sign_in
  delete '/sign_out', to: 'sessions#destroy', as: :sign_out
end
