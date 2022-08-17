class TasksController < ApplicationController
  before_action :require_signed_in
  before_action :set_task, only: [ :edit, :update, :destroy, :change_status]
  before_action :correct_user, only: [:edit, :update, :destroy, ]
  protect_from_forgery
  

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "更新しました"
      redirect_to project_creatives_path(@project)
    else
      flash.now[:danger] = "更新失敗"
      render "users/show"
    end

  end

  def create
    # binding.pry
    @creative = Creative.find_by(id: params[:creative_id])
    @project = Project.find_by(id: params[:project_id])
    @task = Task.new(task_params)
    
    if @task.save
      flash[:success] = "作成しました"
      redirect_to project_creatives_path(@project)
    else
      flash[:danger] = "作成失敗です。入力欄を埋めてください"
      # render project_creatives_path(@project)
      redirect_to project_creatives_path(@project)
    end
  end
  def destroy
    @task.destroy
    flash[:success] = "削除しました"
    redirect_to project_creatives_path(@project.id)
  end

  def change_status
    change = params[:change]
    if change.present?
      @change_task = Task.find_by(id: params[:id])
      @change_task.update(status: change)
      flash[:success] = "更新しました"
      redirect_to project_creatives_path(@project)
    else
      flash[:danger] = "更新失敗しました"
      redirect_to project_creatives_path(@project)
    end
  end
    # 一括削除を受け付ける
  def delete_done_tasks
      done = current_user.tasks.where(status: 2)
      done.destroy_all
      flash[:success] = "削除しました"
      redirect_to project_creatives_path(@project)
  end



  private
  def set_task
    @user = current_user
    @creative = Creative.find(params[:creative_id])
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
  end
  def task_params
    params.require(:task).permit(:creative_id, :name, :status, :complete)
  end
  def correct_user
    unless @project.user_id == current_user.id
      flash[:danger] = "編集できません"
      redirect_to project_creatives_path(@project)
    end
  end
  def sort_tasks(sort)
    if sort.present?
      @tasks = @tasks.where(status: sort)
    end
  end
end
