Rails.application.routes.draw do
  resources :members do
    member do
    patch :ban
    get :ban
    end
  end
  resources :posts do
    resources :comments
  end

  resources :likes, only: [:create, :destroy]


  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    conformations: 'users/conformations'
  }
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
