Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    namespace :admin do
      resources :dashboards, only: [:show] do
        collection do
          get :numbers
          get :linechart
        end
      end
      get 'load_admins', to: 'users#load_admins'
      get 'load_users', to: 'users#load_users'
      get 'load_categories', to: 'categories#load_categories'
      get 'load_brands', to: 'brands#load_brands'
      get 'load_products', to: 'products#load_products'
      get 'load_vouchers', to: 'vouchers#load_vouchers'
    end

    namespace :customer do
      resources :products, only: [:show] do
        collection do
          post :search
          post :select_attribute
          post :add_to_cart
          post :comments
        end

        member do
          get :images
        end
      end
      resources :home do
        collection do
          get :categories
          get :brands
          post :filter_products
          get :get_product_cart
          get :load_default_products
        end
      end
      resources :carts do
        collection do
          post :get_all
          put :update
          post 'delete', to: 'carts#delete_cart_item'
        end
      end
      resources :checkouts do
        collection do
          get :get_order
          post :check_cart
          post :voucher
          post :address
        end
      end
      resources :comments do
        collection do
          post :create
        end
      end
    end

    resources :errors, only: :catch_404
    match "*path", to: "errors#catch_404", via: :all
  end
end
