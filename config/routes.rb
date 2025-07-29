Rails.application.routes.draw do
  devise_for :users 
  root "items#index"

  resources :items, only: %i[index show new create edit update destroy]
end
