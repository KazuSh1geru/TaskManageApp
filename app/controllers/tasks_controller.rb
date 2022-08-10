class TasksController < ApplicationController
  before_action :require_signed_in
  before_action :set_task, only: [:edit, :update, :destroy,]
  before_action :correct_user, only: [:edit, :update, :destroy, ]
  protect_from_forgery
  # indexはいらん
  def index
    @user = current_user
    @project = Project.find(params[:project_id])
    @tasks = current_user.tasks.where(project_id: @project.id).paginate(page: params[:page], per_page: 20)
    @new_task = Task.new
    # @new_task = Task.new(project_id: params[:project_id])

    @sort = params[:sort]
    sort_tasks(@sort)

  end
  
  def edit
    
  end

  def update
    if @task.update(task_params)
      flash[:success] = "更新しました"
      redirect_to project_tasks_path(params[:project_id])
    else
      flash.now[:danger] = "更新失敗"
      render "users/show"
    end

  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "作成しました"
      redirect_to project_tasks_path(params[:project_id])
    else
      flash[:danger] = "作成失敗"
      redirect_to project_tasks_path
      
    end
  end
  def destroy
    @task.destroy
    flash[:success] = "削除しました"
    redirect_to project_tasks_path(params[:project_id])
  end

  def change_status
    change = params[:change]
    if change.present?
      @change_task = Task.find_by(id: params[:id])
      @change_task.update(status: change)
      flash[:success] = "更新しました"
      redirect_to project_tasks_path(params[:project_id])
    else
      flash[:danger] = "更新失敗しました"
      redirect_to project_tasks_path(params[:project_id])
    end
  end
    # 一括削除を受け付ける
  def delete_done_tasks
      done = current_user.tasks.where(status: 2)
      done.destroy_all
      flash[:success] = "削除しました"
      redirect_to project_tasks_path(params[:project_id])
  end

  private
  def set_task
    @task = Task.find(params[:id])
    @project = Project.find(params[:project_id])
  end
  def task_params
    params.require(:task).permit(:project_id, :user_id,:name, :status)
  end
  def correct_user
    unless @task.user_id == current_user.id
      flash[:danger] = "編集できません"
      redirect_to project_tasks_path(params[:project_id])
    end
  end
  def sort_tasks(sort)
    if sort.present?
      @tasks = @tasks.where(status: sort)
    end
  end
end
