Rails.application.routes.draw do
  namespace :admin do
    # root to: 'dashboards#index'
    get '/', to: 'dashboards#index'
    resources :brands
    resources :categories
    resources :vouchers
    delete 'users/:id/delete', to: 'users#destroy'
    resources :products do
      post 'edit_product', to: 'products#edit_product'
    end
    post 'products/show_attribute', to: 'products#show_attribute'
    post 'products/show_attribute2', to: 'products#show_attribute2'
    post 'products/show_no_attribute', to: 'products#show_no_attribute'
    resources :users
    get 'admins', to: 'users#admin'
    resources :orders
    post 'orders/submit', to: 'orders#submit'
    post 'orders/cancel', to: 'orders#cancel'
    post 'orders/success', to: 'orders#success'
  end
end
