Rails.application.routes.draw do
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
end
