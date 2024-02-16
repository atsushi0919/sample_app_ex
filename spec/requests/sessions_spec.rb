require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "ログインページが表示される" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /logout" do
    context "2 回連続ログアウトしたとき" do
      it "エラーが発生しない" do
        delete logout_path
        delete logout_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
   let(:user) { create(:user) }

   describe "remember me" do
    context "ON のとき" do
      it "cookies[:remember_token] が空でない" do
        post login_path, params: {
          session: { email: user.email,
                     password: user.password,
                     remember_me: 1 } }

        expect(cookies[:remember_token]).to_not be_blank
      end
    end

    context "OFF のとき" do
      it "cookies[:remember_token] が空である" do
        post login_path, params: {
          session: { email: user.email,
                     password: user.password,
                     remember_me: 0 } }

        expect(cookies[:remember_token]).to be_blank
      end
    end
   end
 end
end
