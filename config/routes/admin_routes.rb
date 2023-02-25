Rails.application.routes.draw do
  namespace :admin do
    root to: 'dashboards#index'
    get '/', to: 'dashboards#index'
    resources :brands do
      collection do
        get :export_csv
      end
    end
    resources :categories do
      collection do
        get :export_csv
      end
    end
    resources :vouchers
    delete 'users/:id/delete', to: 'users#destroy'
    resources :products do
      post 'edit_product', to: 'products#edit_product'

      collection do
        get :export_csv
      end
    end
    post 'products/show_attribute', to: 'products#show_attribute'
    post 'products/show_attribute2', to: 'products#show_attribute2'
    post 'products/show_no_attribute', to: 'products#show_no_attribute'
    resources :users do
      collection do
        get :export_csv
        get :export_admin_csv
      end
    end
    get 'admins', to: 'users#admin'
    resources :orders
    post 'orders/submit', to: 'orders#submit'
    post 'orders/cancel', to: 'orders#cancel'
    post 'orders/success', to: 'orders#success'
  end
end
