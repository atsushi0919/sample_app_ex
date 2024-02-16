class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      flash.now[:danger] = t("flash.invalid_email_password_combination")
      render "new", status: :unprocessable_entity
    end
  end

  def destroy; end
end
