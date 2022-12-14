Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "sessions#new"
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "signin", to: "sessions#new"
  post "signin", to: "sessions#create"
  delete "signout", to: "sessions#destroy"
  
  # delete "tasks/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
  
  patch "projects/:project_id/creatives/:creative_id/tasks/:id/change_status", to: "tasks#change_status", as: "change"
  
  resources "projects" do
    resources "creatives" do
      resources "tasks"
    end
  end

  
  
  
  # delete "tasks/:id/delete_done_tasks", to: "tasks#delete_done_tasks", as: "done"
end
