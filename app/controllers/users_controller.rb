class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = t("flash.welcome_to_sample_app")
      redirect_to @user
    else
      render "new", status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t("flash.profile_updated")
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  # beforeフィルタ

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    flash[:danger] = t("flash.please_log_in")
    redirect_to login_url, status: :see_other
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
