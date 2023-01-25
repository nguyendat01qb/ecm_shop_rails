Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    namespace :admin do
      get 'load_users', to: 'users#load_users'
      get 'load_categories', to: 'categories#load_categories'
      get 'load_products', to: 'products#load_products'
    end
  end
end
