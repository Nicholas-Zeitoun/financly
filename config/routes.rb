Rails.application.routes.draw do
  resources :transactions
  devise_for :users
  # root to: 'pages#home'
  root to: 'transactions#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/tracking', to: 'transactions#tracking'
  # User routes
  resources :users, only: [:show, :update]
end
