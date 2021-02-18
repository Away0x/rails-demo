Rails.application.routes.draw do
  root 'home#index'

  get 'home/index' => 'home#index'

  get 'login' => 'accounts#login'
  get 'signup' => 'accounts#signup'
  post 'create_account' => 'accounts#create_account'
  post 'create_login' => 'accounts#create_login'
end
