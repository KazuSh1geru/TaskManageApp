Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "tasks#index"
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "signin", to: "sessions#new"
  post "signin", to: "sessions#create"
  delete "signout", to: "sessions#destroy"
  resources "tasks"
  
  patch "tasks/:id/change_status", to: "tasks#change_status"
  delete "tasks/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
  # delete "tasks/:id/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
end
