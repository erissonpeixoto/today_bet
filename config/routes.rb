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
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
