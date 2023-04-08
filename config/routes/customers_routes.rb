Rails.application.routes.draw do
  root to: 'home#index'
  resources :products, only: [:show]

  resources :comments do
    post 'reply_comment', to: 'comments#reply_comment'
  end

  resource :carts, only: [:show] do
    get 'check_amount', to: 'cart#check_amount'
  end

  resource :checkout do
    post '/payment', to: 'checkouts#payment'
    get '/stripe', to: 'checkouts#stripe_payment'
    post '/payment_with_stripe', to: 'checkouts#payment_with_stripe'
    post '/create_order_stripe', to: 'checkouts#create_order_stripe'
    post '/payment_with_momo', to: 'checkouts#payment_with_momo'
    get '/success', to: 'checkouts#success'
    get '/error', to: 'checkouts#error'
    post '/info_checkout', to: 'checkouts#info_checkout'
    post '/voucher', to: 'checkouts#voucher'
    post '/check_order_stripe', to: 'checkouts#check_order_stripe'
    post '/check_cart', to: 'checkouts#check_cart'
    post '/refund_stripe', to: 'orders#refund_stripe'
  end

  resource :webhook do
    post '/stripe', to: 'webhooks#stripe'
    post '/momo', to: 'webhooks#momo'
  end

  resource :user, only: %i[edit update] do
    get '/profile/edit', to: 'users#edit'
    patch '/profile/edit', to: 'users#update'
    post '/profile', to: 'users#show_profile'
    get '/password/change', to: 'users#password'
    post '/password', to: 'users#show_password'
    post 'addresses/change_address', to: 'addresses#change_address'
    post 'addresses/show', to: 'addresses#show_address'
    resource :order, only: [:show] do
      post '/show_order', to: 'orders#show_order'
    end
    post 'order/detail', to: 'orders#order_detail'
    get 'order/:id', to: 'orders#show_order_detail'
    resources :addresses do
      post '/:slug', to: 'addresses#edit'
    end
  end
end
