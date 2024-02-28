require "rails_helper"

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "#new" do
    it "password_reset[email]というname属性のinputタグが表示される" do
      get new_password_reset_path
      expect(response.body).to include "name=\"password_reset[email]\""
    end
  end

  describe "#create" do
    it "無効なメールアドレスなら flash が表示される" do
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash).to be_any
    end

    context "有効なメールアドレスの場合" do
      it "reset_digest が変更される" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(user.reset_digest).to_not eq user.reload.reset_digest
      end

      it "送信メールが1件増える" do
        expect do
          post password_resets_path, params: { password_reset: { email: user.email } }
        end.to change(ActionMailer::Base.deliveries, :count).by 1
      end

      it "flash が表示される" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(flash).to be_any
      end

      it "root にリダイレクトされる" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#edit" do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get(:@user)
    end

    it "メールアドレスもトークンも有効なら隠しフィールドにメールアドレスが表示される" do
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response.body).to include(
        "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\" autocomplete=\"off\" />"
      )
    end

    it "メールアドレスが間違っていれば root にリダイレクトする" do
      get edit_password_reset_path(@user.reset_token, email: "")
      expect(response).to redirect_to root_path
    end

    it "無効なユーザなら root にリダイレクトする" do
      @user.update(activated: !@user.activated)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to root_path
    end

    it "トークンが無効なら root にリダイレクトする" do
      get edit_password_reset_path("wrong token", email: @user.email)
      expect(response).to redirect_to root_path
    end
  end

  describe "#update" do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get(:@user)
    end

    context "有効なパスワードの場合" do
      it "ログイン状態になる" do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: "password",
                                                                        password_confirmation: "password" } }
        expect(session[:user_id]).to_not be_nil
      end

      it "flash が表示される" do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: "password",
                                                                        password_confirmation: "password" } }
        expect(flash).to be_any
      end

      it "ユーザの詳細ページにリダイレクトする" do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: "password",
                                                                        password_confirmation: "password" } }
        expect(response).to redirect_to @user
      end
    end

    it "パスワードと再入力が一致しなければエラーメッセージが表示される" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: "password",
                                                                      password_confirmation: "hogehoge" } }
      expect(response.body).to include "<div id=\"error_explanation\">"
    end

    it "パスワードが空なら、エラーメッセージが表示される" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: "",
                                                                      password_confirmation: "" } }
      expect(response.body).to include "<div id=\"error_explanation\">"
    end
  end
end
