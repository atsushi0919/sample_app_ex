class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    handle_login(user)
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private

  def handle_login(user)
    if user&.authenticate(params[:session][:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def handle_successful_login(user)
    forwarding_url = session[:forwarding_url]
    reset_session
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    log_in user
    redirect_to forwarding_url || user
  end

  def handle_failed_login
    flash.now[:danger] = t("flash.invalid_email_password_combination")
    render "new", status: :unprocessable_entity
  end
end
