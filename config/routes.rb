Rails.application.routes.draw do
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :sessions
  delete '/logout' => 'sessions#destroy', as: :logout
  get '/products/get_product_item' => 'products#get_product_item', as: :get_product_item

  resources :products, only: [:show] do
    get :search, on: :collection
  end
  resources :categories
  resources :cart_items
  resources :favorites
  resources :addresses do
    member do
      put :set_default_address
    end
  end
  resources :transaction_orders do
    member do
      post 'pay'
    end
  end

  namespace :dashboard do
    scope 'profile' do
      controller :profile do
        get :user_message
        put :update_message
      end
    end
    resources :favorites
    resources :transaction_orders do
      member do
        post 'to_pay'
        post 'pay'
        post 'over'
        delete :destroy, action: :destroy
      end
    end
    resources :addresses, only: [:index]
  end

  namespace :admin do
    root 'transaction_orders#index'
    resources :sessions
    resources :categories

    post 'sizes/:product_id/select' => 'sizes#select', as: :select_size
    post 'colors/:product_id/select' => 'colors#select', as: :select_color
    resources :products do
      resources :product_items
      resources :sizes
      resources :colors
    end
    resources :transaction_orders do
      member do
        post 'delivery'
        delete :destroy, action: :destroy
      end
    end
  end
end
