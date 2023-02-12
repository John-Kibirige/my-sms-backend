Rails.application.routes.draw do
  
  post '/login', to: 'users#login'
  resources :admins, only: [:create]
  resources :teachers
  resources :parents
  resources :students
  resources :streams
  resources :subjects do 
    resources :exams
  end
end
