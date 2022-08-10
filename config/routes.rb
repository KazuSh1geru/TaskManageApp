Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "projects#index"
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "signin", to: "sessions#new"
  post "signin", to: "sessions#create"
  delete "signout", to: "sessions#destroy"

  # 複雑にしてるから一回引っ込める
  # delete "tasks/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
  
  # project登録
  resources :projects do
    resources :tasks
  end
  # get 'projects', to: 'projects#index', as: 'projects'
  # post 'projects/:project_id', to: 'projects#create', as: 'project'
  # delete 'projects/:project_id', to: 'projects#destroy'

  
  patch "tasks/:id/change_status", to: "tasks#change_status", as: "change"
  
  # delete "tasks/:id/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
end
