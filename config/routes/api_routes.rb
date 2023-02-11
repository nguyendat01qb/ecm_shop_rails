Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    namespace :admin do
      get 'load_admins', to: 'users#load_admins'
      get 'load_users', to: 'users#load_users'
      get 'load_categories', to: 'categories#load_categories'
      get 'load_brands', to: 'brands#load_brands'
      get 'load_products', to: 'products#load_products'
    end

    namespace :customer do
      resources :products do
        collection do
          post :search
          post :load_more
          post :select_attribute
          post :add_to_cart
        end
      end
      resources :home do
        collection do
          post :filter_products
          get :get_product_cart
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
    end
  end
end
