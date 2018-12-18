Rails.application.routes.draw do
  resources :events do
    collection do
      get 'past'
      get 'upcoming'
    end
  end

  resources :organizers, only: [:index,:show,:new,:create]
  resources :subscribers, only: [:new, :create]

  get '/admin_panel/signin', to: 'admin_panel#index'
  post '/admin_panel/signin', to: 'admin_panel#signin'
  get '/admin_panel/signout', to: 'admin_panel#signout'

  root "events#index", as: 'home'
end
