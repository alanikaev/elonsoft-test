Rails.application.routes.draw do
  resources :events do
    collection do
      get 'past'
      get 'upcoming'
    end
  end

  resources :organizers
  resources :subscribers

  root "events#index", as: 'home'
end
