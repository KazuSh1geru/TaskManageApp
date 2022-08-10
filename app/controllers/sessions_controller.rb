class SessionsController < ApplicationController
  before_action :require_signed_in, only: [:destroy]
  before_action :already_signed_in, only: [:new, :create]
  
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if signin(email, password)
      flash[:success] = "ログインに成功"
      redirect_to projects_path
    else
      flash.now[:danger] = "ログインに失敗"
      render :new
    end
  end

  def destroy
    # DBに保管していないからnilにする
    session[:user_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to signin_url
  end
  private
  def signin(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
end
