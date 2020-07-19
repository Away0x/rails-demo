Rails.application.routes.draw do
  resources :line_items
  resources :carts
  # root 网页根路径
  # as: 'store_idnex' 创建了 store_index_path 和 store_index_url 两个方法
  root 'store#index', as: 'store_index'

  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
