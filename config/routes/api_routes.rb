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
      resources :product do
        collection do
          post :search
          post :load_more
          post :select_attribute
        end
      end
      resources :home do
        collection do
          post :filter_products
        end
      end
    end
  end
end
