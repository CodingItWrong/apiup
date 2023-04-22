Rails.application.routes.draw do
  use_doorkeeper
  jsonapi_resources :users, only: %w[create]
end
