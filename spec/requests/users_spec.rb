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

        expect(response).to have_http_status(:found) # とりあえず
        expect(response).to redirect_to User.last
      end
    end
  end
end
