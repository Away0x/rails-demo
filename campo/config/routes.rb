require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  root to: 'home#index'

  resource :setup, only: [:show, :update], controller: 'setup'

  ############### auth ###############
  get '/sign_up', to: 'users#new', as: :sign_up
  resources :users, only: [:create] do
    collection do
      post 'validate/:attribute', to: 'users#validate', constraints: { attribute: /name|username|email|password/ }
    end
  end

  resource :session, only: [:create]
  get '/sign_in', to: 'sessions#new', as: :sign_in
  delete '/sign_out', to: 'sessions#destroy', as: :sign_out

  resource :password_reset, only: [:show, :create, :edit, :update]

  get '/auth/:provider/callback', to: 'auths#callback', as: :auth_callback
  namespace :auth do
    resources :users, only: [:new, :create]
  end

  ############### forums ###############
  resources :forums, only: [:index, :show] do
    collection do
      post 'validate/:attribute', to: 'forums#validate', constraints: { attribute: /name|slug/ }
    end
  end

  ############### topics ###############
  get 'topics/:id/(:number)', to: 'topics#show', as: 'topic', constraints: { id: /\d+/, number: /\d+/ }
  resources :topics, only: [:new, :create, :edit, :update] do
    member do
      put :trash
    end

    resource :subscription, only: [:update, :destroy]
  end

  ############### posts ###############
  resources :posts, only: [:show, :create, :edit, :update] do
    member do
      post :reply
      put :trash
    end
  end
  post 'posts/:id/reaction/:type', to: 'reactions#create', as: :post_reaction, constraints: { type: /like|dislike/ }
  delete 'posts/:id/reaction/:type', to: 'reactions#destroy', constraints: { type: /like|dislike/ }

  ############### settings ###############
  namespace :settings do
    resource :account, only: [:show, :update] do
      post 'validate/:attribute', to: 'accounts#validate', constraints: { attribute: /name|username|email/ }
    end
    resource :password, only: [:show, :update]
  end

  ############### profile ###############
  get '/@:username', to: 'profile/topics#index', as: 'profile'
  scope '/@:username', module: 'profile', as: 'profile' do
    resources :posts, only: [:index]
  end

  ############### other ###############
  get '/search', to: 'search#index', as: :search
  resources :attachments, only: [:create]
  resource :preview, only: [:create]
  resources :notifications, only: [:index]

  ############### admin ###############
  namespace :admin do
    root to: 'dashboard#index'
    resources :users
    resources :forums
    resources :topics
    resource :settings
    resources :posts
    resources :attachments
  end

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  if Rails.env.development?
    get '/ui/(:page)', to: 'ui#page', as: :ui
  end
end
