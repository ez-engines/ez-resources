Rails.application.routes.draw do
  root to: 'home#index'

  resources :users do
    resources :posts do
      resources :comments
    end
  end
end
