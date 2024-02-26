class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Sample App アカウントの有効化"
  end

  def password_reset
    @greeting = "こんにちは"

    mail to: "to@example.org"
  end
end
