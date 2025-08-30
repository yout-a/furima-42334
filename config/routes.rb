Rails.application.routes.draw do
  devise_for :users
  root "items#index"

  resources :items do
  resources :orders, only: [:index, :create]
  delete "images/:attachment_id", to: "items#destroy_image", as: :image
end
end


