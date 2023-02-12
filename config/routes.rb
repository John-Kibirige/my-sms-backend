Rails.application.routes.draw do
  resources :exams
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
  resources :parents
  resources :students
  resources :streams
  resources :subjects
end
