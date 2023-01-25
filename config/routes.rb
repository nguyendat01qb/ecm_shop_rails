class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'register' }

  devise_scope :user do
    get 'register', to: 'devise/registrations#new'
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
  end

  # include routes of API from file config/routes/api_routes
  draw :api_routes
  # include routes of API from file config/routes/admin_routes
  draw :admin_routes
  # include routes of API from file config/routes/customers_routes
  draw :customers_routes
end
