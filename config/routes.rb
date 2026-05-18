Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :matches, only: [ :show ] do
    resources :tips, only: [ :create ] do
      resources :votes,    only: [ :create ]
      resources :comments, only: [ :create ]
    end
  end

  get "ranking", to: "ranking#index", as: :ranking

  namespace :cup do
    root to: "pools#index"
    resources :pools do
      resources :guesses, only: [ :index, :create, :update ]
    end
    get  "join/:code", to: "joins#show",   as: :join
    post "join/:code", to: "joins#create"
  end

  namespace :admin do
    root "dashboard#index"
    resources :matches do
      resources :tips, only: [ :index ] do
        collection do
          patch :set_result
        end
      end
    end
    resources :football_clubs
    resources :cup_matches do
      member do
        patch :set_result
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
