class UsersController < ApplicationController
  before_action :require_signed_in, only: [:show]
  before_action :already_signed_in, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success]  = "登録しました"
      redirect_to projects_path
    else
      flash.now[:danger]  = "登録に失敗しました"
      render :new

    end
  end
  private
  def user_params
    params.require(:user).permit(
      :name, :birthday, :email, :password, :password_confirmation
    )
  end
end
