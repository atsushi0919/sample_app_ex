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
end
