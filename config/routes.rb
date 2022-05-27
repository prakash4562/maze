Rails.application.routes.draw do
  resources :members, except: [:show] do
    collection { post :import }
    member do
      patch :ban
      get :ban
    end
  end

  get 'members/upload', to: 'members#upload', as: 'upload_users'

  get 'posts/report', to: 'members#report', as: 'report'
  get 'limited_report', to: 'members#limited_report', as: 'limited_report'

  resources :posts do
    collection { post :import }
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
