Rails.application.routes.draw do
  resources :events do
    collection do
      get 'past'
      get 'upcoming'
    end
  end

  resources :organizers

  root "events#index", as: 'home'
end
