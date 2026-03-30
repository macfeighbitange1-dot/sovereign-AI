Rails.application.routes.draw do
  # The Sovereign Ledger Dashboard and API
  resources :wallets, only: [:show] do # <--- Added :show here
    member do
      # Query Endpoints
      get :balance
      get :history
      
      # Command Endpoints
      post :deposit
      post :withdraw
    end
  end

  # Node Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end
