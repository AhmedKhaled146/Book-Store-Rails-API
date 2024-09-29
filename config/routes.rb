Rails.application.routes.draw do

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
     controllers: {
       sessions: 'users/sessions',
       registrations: 'users/registrations'
 }

  resources :categories
  # get "categories", to: "category#index"
  # post "categories", to: "category#create"
  # get "categories/:id", to: "category#show"
  # put "categories/:id", to: "category#update"
  # delete "categories/:id", to: "category#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
