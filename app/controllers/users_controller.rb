class UsersController < ApplicationController
  before_action :require_signed_in, only: [:show]
  before_action :already_signed_in, only: [:new, :create]
  
  def show
    puts params
    @user = current_user
    # @tasks = current_user.tasks.all
    @tasks = current_user.tasks.paginate(page: params[:page], per_page: 20)
    @new_task = Task.new

    # integerで受け取る様にする
    sort = params[:sort]
    sort_tasks(sort)
    # 変更を受け付ける
    change = params[:change]
    change_status(change)
    # 一括削除を受け付ける
    delete_done = params[:delete_done]
    delete_done_tasks(delete_done)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success]  = "登録しました"
      redirect_to root_path
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
  def sort_tasks(sort)
    if sort.present?
      @tasks = @tasks.where(status: sort)
    end
  end
  def change_status(change)
    if change.present?
      task_id = params[:task_id]
      @change_task = Task.find_by(id: task_id)
      @change_task.update(status: change)
    end
  end
  def delete_done_tasks(delete_done)
    if delete_done.present?
      @done = current_user.tasks.where(status: 2)
      @done.destroy_all
      flash[:success] = "削除しました"
      redirect_to root_path
    end
  end
end
