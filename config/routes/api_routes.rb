Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    namespace :admin do
      get 'load_categories', to: 'categories#load_categories'
      # get 'list_categories', to: 'categories#list_categories'
      # resources :categories, only: [:index, :create, :update, :destroy]

      # namespace :pagination do
      #   resource :default_options, only: [] do
      #     post :index
      #   end
      # end
    end
  end
end
