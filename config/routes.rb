Rails.application.routes.draw do
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :sessions
  delete '/logout' => 'sessions#destroy', as: :logout

  resources :products, only: [:show] do
    get :search, on: :collection
  end
  resources :categories
  resources :cart_items
  resources :addresses do
    member do
      put :set_default_address
    end
  end
  resources :transaction_orders

  namespace :dashboard do
    scope 'profile' do
      controller :profile do
        get :password
        put :update_password
      end
    end

    resources :transaction_orders, only: [:index]
    resources :addresses, only: [:index]
  end

  namespace :admin do
    root 'sessions#new'
    resources :sessions
    resources :categories
    resources :products do
      resources :product_images
    end
  end
end
