require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "アカウントの有効化" do
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    it "正しいタイトルで送信される" do
      expect(mail.subject).to eq("Sample App アカウントの有効化")
    end

    it "送信先が user.email である" do
      expect(mail.to).to eq([user.email])
    end

    it "送信元が foo@example.com である" do
      expect(mail.from).to eq(["foo@example.com"])
    end

    it "メール本文にユーザ名が表示される" do
      expect(mail.html_part.body).to match(user.name)
      expect(mail.text_part.body).to match(user.name)
    end

    it "メール本文にユーザの activation_token が表示される" do
      expect(mail.body.encoded).to match(user.activation_token)
    end

    it "メール本文にユーザの email が表示される" do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe "パスワードリセット" do
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    it "正しいタイトルで送信される" do
      expect(mail.subject).to eq("Sample App パスワードリセット")
    end

    it "user.email に送信される" do
      expect(mail.to).to eq([user.email])
    end

    it "foo@example.com から送信される" do
      expect(mail.from).to eq(["foo@example.com"])
    end

    it "メール本文に reset_token が表示される" do
      expect(mail.body.encoded).to match(user.reset_token)
    end

    it "メール本文にユーザの email が表示される" do
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end
