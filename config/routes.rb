Rails.application.routes.draw do
  root "items#index"
  resources :items, only: %i[index show new create edit update destroy]
end
