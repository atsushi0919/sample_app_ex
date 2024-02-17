require "rails_helper"

RSpec.describe "Users", type: :request do
  include ApplicationHelper

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  def get_title_text(response)
    Nokogiri::HTML(response.body).css("title").text
  end

  describe "GET /signup" do
    it "サインアップページが表示される" do
      get signup_path
      # レスポンス
      expect(response).to have_http_status(:success)
      # タイトル
      title_text = get_title_text(response)
      expect(title_text).to eq(full_title("Sign up"))
    end
  end

  describe "POST /users #create" do
    context "無効な値を POST したとき" do
      let(:user_params) do
        { user: { name: "",
                  email: "user@invlid",
                  password: "foo",
                  password_confirmation: "bar" } }
      end
      it "エラーが発生する" do
        expect do
          post users_path, params: user_params
        end.to_not change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("users/new")
      end
    end

    context "有効な値を POST したとき" do
      let(:user_params) do
        { user: { name: "Example User",
                  email: "user@example.com",
                  password: "password",
                  password_confirmation: "password" } }
      end

      it "保存できる" do
        expect do
          post users_path, params: user_params
        end.to change(User, :count).by 1
        expect(flash).to be_any
        expect(response).to redirect_to User.last
      end
    end
  end

  describe "PATCH /users" do
    let(:user) { create(:user) }

    it "正しいタイトルが表示される" do
      get edit_user_path(user)
      expect(response.body).to include full_title("Edit user")
    end

    context "無効な値を送信したとき" do
      let(:invalid_user_params) do
        { user: { name: "",
                  email: "foo@invalid",
                  password: "foo",
                  password_confirmation: "bar" } }
      end

      it "更新できない" do
        patch user_path(user), params: invalid_user_params
        user.reload
        expect(user.name).to_not eq ""
        expect(user.email).to_not eq "foo@invlid"
        expect(user.password).to_not eq "foo"
        expect(user.password_confirmation).to_not eq "bar"
      end

      it "更新アクション後に edit のページが表示される" do
        get edit_user_path(user)
        patch user_path(user), params: invalid_user_params
        expect(response.body).to include full_title("Edit user")
      end

      it "エラー表示が正しく表示される" do
        patch user_path(user), params: invalid_user_params
        expect(response.body).to include "入力情報に 4 件のエラーがあります"
      end
    end

    context "有効な値を送信したとき" do
      before do
        @name = "Foo Bar"
        @email = "foo@bar.com"
        patch user_path(user), params: {
          user: { name: @name,
                  email: @email,
                  password: "",
                  password_confirmation: "" }
        }
      end

      it "更新できること" do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it "Users#show にリダイレクトする" do
        expect(response).to redirect_to user
      end

      it "flash が表示される" do
        expect(flash).to be_any
      end
    end
  end
end
