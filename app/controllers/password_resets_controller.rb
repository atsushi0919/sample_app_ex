class PasswordResetsController < ApplicationController
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
end
