class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Sample App アカウントの有効化"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Sample App パスワードリセット"
  end
end
