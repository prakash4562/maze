Rails.application.routes.draw do
  resources :members do
    member do
    patch :ban
    get :ban
    end
  end
  get 'posts/report', to: 'members#report', as: 'report'
  get 'posts/demo', to: 'posts#demo', as: 'demo'

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
end
