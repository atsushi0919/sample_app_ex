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
      before do
        ActionMailer::Base.deliveries.clear
      end

      let(:user_params) do
        { user: { name: "Example User",
                  email: "user@example.com",
                  password: "password",
                  password_confirmation: "password" } }
      end

      it "メールが1件存在する" do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "保存できる" do
        expect do
          post users_path, params: user_params
        end.to change(User, :count).by 1
        expect(flash).to be_any
        expect(response).to redirect_to root_path
      end

      it "保存時点では activate されていない" do
        post users_path, params: user_params
        expect(User.last).to_not be_activated
      end
    end
  end

  describe "get /users/{id}/edit" do
    let(:user) { create(:user, :michael) }

    it "ログインしていればタイトルが正しく表示される" do
      sign_in(user)
      get edit_user_path(user)
      expect(response.body).to include full_title("Edit user")
    end

    context "未ログインのとき" do
      it "flash が表示される" do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it "ログインページにリダイレクトされる" do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it "ログインすると編集ページにリダイレクトされる" do
        get edit_user_path(user)
        sign_in(user)
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context "別のユーザを編集しようとしたとき" do
      let(:other_user) { create(:user, :archer) }
      before do
        sign_in(user)
      end

      it "flash は表示されない" do
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end

      it "root_path にリダイレクトされる" do
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH /users" do
    let(:user) { create(:user) }

    it "ログインしていれば正しいタイトルが表示される" do
      sign_in(user)
      get edit_user_path(user)
      expect(response.body).to include full_title("Edit user")
    end

    context "無効な値を送信したとき" do
      let!(:invalid_user_params) do
        { user: { name: "",
                  email: "foo@invalid",
                  password: "foo",
                  password_confirmation: "bar" } }
      end
      before do
        sign_in(user)
      end

      it "更新できない" do
        invalid_name = invalid_user_params[:user][:name]
        invalid_email = invalid_user_params[:user][:email]
        invalid_password = invalid_user_params[:user][:password]
        invalid_password_confirmation = invalid_user_params[:user][:password_confirmation]
        patch user_path(user), params: invalid_user_params
        user.reload

        expect(user.name).to_not eq invalid_name
        expect(user.email).to_not eq invalid_email
        expect(user.password).to_not eq invalid_password
        expect(user.password_confirmation).to_not eq invalid_password_confirmation
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
        sign_in(user)
        @name = "Foo Bar"
        @email = "foo@bar.com"
        patch user_path(user), params: {
          user: { name: @name,
                  email: @email,
                  password: "",
                  password_confirmation: "" }
        }
      end

      it "更新できる" do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it "更新後 Users#show にリダイレクトされる" do
        expect(response).to redirect_to user
      end

      it "flash が表示される" do
        expect(flash).to be_any
      end
    end

    context "未ログインのとき" do
      it "flash が表示される" do
        patch user_path(user), params: {
          user: { name: user.name,
                  email: user.email }
        }
        expect(flash).to_not be_empty
      end

      it "ログインページにリダイレクトされる" do
        patch user_path(user), params: {
          user: { name: user.name,
                  email: user.email }
        }
        expect(response).to redirect_to login_path
      end
    end

    context "別のユーザを編集しようとしたとき" do
      let(:other_user) { create(:user, :archer) }
      before do
        sign_in(user)
        patch user_path(other_user), params: { user: { name: user.name,
                                                       email: user.email } }
      end

      it "flash が表示されない" do
        expect(flash).to be_empty
      end

      it "root にリダイレクトする" do
        expect(response).to redirect_to root_path
      end
    end

    context "admin 属性を更新しようとしたとき" do
      it "更新できない" do
        sign_in(user)
        expect(user).to_not be_admin

        patch user_path(user), params: {
          user: { password: "password",
                  password_confirmation: "password",
                  admin: true }
        }
        user.reload
        expect(user).to_not be_admin
      end
    end
  end

  describe "GET /users" do
    let(:user) { create(:user, :michael) }
    let(:not_activated_user) { create(:user, :malory) }

    context "非ログイン時" do
      it "login_path にリダイレクトされる" do
        get users_path
        expect(response).to redirect_to login_path
      end

      it "activate されていないユーザーは表示されない" do
        sign_in(user)
        get users_path
        expect(response.body).to_not include not_activated_user.name
      end
    end
  end

  describe "pagination" do
    let(:user) { create(:user, :michael) }

    before do
      30.times do
        create(:continuous_users)
      end
      sign_in(user)
      get users_path
    end

    it "ページネーションが表示される" do
      expect(response.body).to include '<ul class="pagination ">'
    end

    it "各ユーザのリンクが存在する" do
      User.page(1).each do |_user|
        expect(response.body).to include "<a href=" # {user_path(user)}">"
      end
    end
  end

  describe "DELETE /users/{id}" do
    let!(:admin_user) { create(:user, :michael) }
    let!(:other_user) { create(:user) }

    context "admin ユーザでログインしているとき" do
      it "ユーザを削除できる" do
        sign_in(admin_user)
        expect do
          delete user_path(other_user)
        end.to change(User, :count).by(-1)
      end
    end
  end

  describe "GET /users/{id}/following" do
    let(:user) { create(:user) }

    it "未ログインならログインページにリダイレクトする" do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  describe "GET /users/{id}/followers" do
    let(:user) { create(:user) }

    it "未ログインならログインページにリダイレクトする" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
