Rails.application.routes.draw do
  devise_for :users  # ← Deviseを導入する場合はこれを追加
  root "items#index"

  resources :items, only: %i[index show new create edit update destroy]
end
