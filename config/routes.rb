Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :clock_ins, only: [:index, :create]
  get "/feed" => "clock_ins#feed"

  resources :follows, only: [:create]
  delete "/follows" => "follows#delete"

end
