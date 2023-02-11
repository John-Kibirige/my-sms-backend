Rails.application.routes.draw do
  resources :parents
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
end
