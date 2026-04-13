Rails.application.routes.draw do
  devise_for :users

  root "matches#index"

  resources :matches, only: [:index, :show] do
    resources :tips, only: [:create] do
      resources :votes,    only: [:create]
      resources :comments, only: [:create]
    end
  end

  namespace :admin do
    root "dashboard#index"
    resources :matches
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
