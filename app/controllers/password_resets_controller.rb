class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("flash.sent_reset_mail")
      redirect_to root_url
    else
      flash.now[:danger] = t("flash.email_not_found")
      render "new", status: :unprocessable_entity
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      @user.update(reset_digest: nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # before フィルタ

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("flash.password_reset_has_expired")
    redirect_to new_password_reset_url
  end
end
