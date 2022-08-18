class ProjectsController < ApplicationController
  before_action :require_signed_in
  before_action :set_project, only: [:show, :edit, :update, :destroy,]
  before_action :move_show, only: [:show]
  before_action :correct_user, only: [:show, :edit, :update, :destroy, ]

  def index
    @user = current_user
    @projects = current_user.projects.all
    @new_project = Project.new
  end
  def edit
  end

  def show
    @user = current_user
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      flash[:success] = "作成しました"
      redirect_to projects_path
    else
      flash[:danger] = "作成失敗. プロジェクト名を訂正してください"
      redirect_to projects_path
    end
  end

  def destroy
    @project.creatives.each do |creative|
      creative.tasks.each do |task|
        task.destroy
      end
      creative.destroy
    end
    @project.destroy
    flash[:success] = "削除しました"
    redirect_to projects_path(params[:project_id])
  end

  def show
    @user = current_user
    @projects = current_user.projects.all
    @new_project = Project.new

  end

  def update
    if @project.update(project_params)
      flash[:success] = "更新しました"
      redirect_to projects_path
    else
      flash[:danger] = "更新失敗"
      redirect_to projects_path
    end
  end
  private
  def set_project
    @project = Project.find(params[:id])
  end
  def move_show
    @project = Project.find(params[:id])
    if @project.creatives.length > 0
      @project.creatives.each do |creative|
        unless creative.tasks.length > 2
          flash[:danger] = "タスクを3つ以上登録してください"
          redirect_to project_creatives_path(@project)
          return
        end
      end
      # redirect_to project_path(@project)
      return
    else
      flash[:danger] = "制作物を登録してください"
      redirect_to project_creatives_path(@project)
    end
  end
  def project_params
    params.require(:project).permit(:name)
  end
  def correct_user
    unless @project.user_id == current_user.id
      flash[:danger] = "編集できません"
      redirect_to projects_path
    end
  end
end