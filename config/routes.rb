Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :tasks
      resources :users, param: :email
      post '/auth/login', to: 'authentication#login'
      get '/auth/me', to: 'authentication#get_me'
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
