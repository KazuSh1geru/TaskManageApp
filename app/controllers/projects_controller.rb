class ProjectsController < ApplicationController
  before_action :require_signed_in
  before_action :set_project, only: [:edit, :update, :destroy,]
  before_action :correct_user, only: [:edit, :update, :destroy, ]

  def index
    @user = current_user
    @projects = current_user.projects.all
    @new_project = Project.new
  end

  def edit
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      flash[:success] = "作成しました"
      redirect_to projects_path
    else
      flash.now[:danger] = "作成失敗"
      render projects_path
    end
  end

  def destroy
  end

  def show
  end

  def update
  end
  private
  def set_project
    @project = Project.find(params[:id])
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
