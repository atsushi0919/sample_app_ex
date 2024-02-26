require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { create(:user) }
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
end
