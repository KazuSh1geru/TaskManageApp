class CreativesController < ApplicationController
  before_action :require_signed_in
  before_action :set_creative, only: [:edit, :update, :destroy,]
  before_action :correct_user, only: [:edit, :update, :destroy, ]
  protect_from_forgery
  # indexはいらん
  def index
    # binding.pry
    @user = current_user
    @project = Project.find_by(id: params[:project_id])
    @creatives = @project.creatives.paginate(page: params[:page], per_page: 20)
    @new_creative = Creative.new
    @new_task = Task.new
    # @new_creative = creative.new(project_id: params[:project_id])
  end
  
  def edit
    
  end

  def update
    if @creative.update(creative_params)
      flash[:success] = "更新しました"
      redirect_to project_creatives_path(params[:project_id])
    else
      flash.now[:danger] = "更新失敗"
      render "users/show"
    end

  end

  def create
    # binding.pry
    @creative = Creative.new(creative_params)
    if @creative.save
      flash[:success] = "作成しました"
      redirect_to project_creatives_path(params[:project_id])
    else
      flash[:danger] = "作成失敗"
      redirect_to project_creatives_path
    end
  end

  def destroy
    @creative.tasks.each do |task|
      task.destroy
    end
    @creative.destroy
    flash[:success] = "削除しました"
    redirect_to project_creatives_path(params[:project_id])
  end

  private
  def set_creative
    @user = current_user
    @creative = Creative.find(params[:id])
    @project = Project.find(params[:project_id])
  end
  def creative_params
    params.require(:creative).permit(:project_id,:name)
  end
  def correct_user
    unless @project.user_id == current_user.id
      flash[:danger] = "編集できません"
      redirect_to project_creatives_path(params[:project_id])
    end
  end
end
