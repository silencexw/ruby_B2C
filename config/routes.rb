Rails.application.routes.draw do
  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :sessions
  delete '/logout' => 'sessions#destroy', as: :logout

  resources :products
  resources :categories
  resources :cart_items
  resources :addresses do
    member do
      put :set_default_address
    end
  end
  resources :transaction_orders

  namespace :admin do
    root 'sessions#new'
    resources :sessions
    resources :categories
    resources :products do
      resources :product_images
    end
  end
end
