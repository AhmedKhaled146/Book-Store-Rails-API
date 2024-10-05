Rails.application.routes.draw do
  get "bookings/create"

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
     controllers: {
       sessions: 'users/sessions',
       registrations: 'users/registrations'
 }

  # Get All books
  get 'all_books', to: 'books#all_books'

  resources :categories do
    resources :books
  end

  # Admin Can see Booking Table
  get "booking", to: "bookings#index"

  # Book a Book
  post "booking/:book_id", to: "bookings#create"

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
