Rails.application.routes.draw do
  resources :subjects
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
  resources :parents
  resources :students
  resources :streams
end
