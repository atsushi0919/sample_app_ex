require "rails_helper"

RSpec.describe "Microposts", type: :request do
  describe "#create" do
    context "未ログインのとき" do
      it "登録されない" do
        expect {
          post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
        }.to_not change(Micropost, :count)
      end

      it "ログインページにリダイレクトされる" do
        post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user, :archer) }

    before do
      @post = create(:most_recent)
    end

    context "他のユーザの投稿を削除したとき" do
      before do
        sign_in user
      end

      it "削除されない" do
        expect {
          delete micropost_path(@post)
        }.to_not change(Micropost, :count)
      end

      it "root にリダイレクトされる" do
        delete micropost_path(@post)
        expect(response).to redirect_to root_path
      end
    end

    context "未ログインの場合" do
      it "削除されない" do
        expect {
          delete micropost_path(@post)
        }.to_not change(Micropost, :count)
      end

      it "ログインページにリダイレクトされる" do
        delete micropost_path(@post)
        expect(response).to redirect_to login_path
      end
    end
  end
end
