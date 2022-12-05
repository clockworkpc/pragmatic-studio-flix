Rails.application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  resource :session, only: %i[new create destroy]
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  resources :users
  get '/signup', to: 'users#new'
end
