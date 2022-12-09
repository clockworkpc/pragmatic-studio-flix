Rails.application.routes.draw do
  root 'movies#index'

  resources :genres

  resources :movies do
    resources :reviews
    resources :favourites, only: %i[create destroy]
  end

  get 'movies/filter/:filter', to: 'movies#index', as: :filtered_events

  resource :session, only: %i[new create destroy]
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  resources :users
  get '/signup', to: 'users#new'
end
