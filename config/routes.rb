Rails.application.routes.draw do
  resources :streams
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
  resources :parents
  resources :students
end
