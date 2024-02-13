require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  def get_title_text(response)
    Nokogiri::HTML(response.body).css("title").text
  end

  describe "GET /" do
    it "home ページが表示される" do
      get root_path
      # レスポンス
      expect(response).to have_http_status(:success)
      # タイトル
      title_text = get_title_text(response)
      expect(title_text).to eq(base_title)
    end
  end

  describe "GET /help" do
    it "help ページが表示される" do
      get help_path
      # レスポンス
      expect(response).to have_http_status(:success)
      # タイトル
      title_text = get_title_text(response)
      expect(title_text).to eq("Help | #{base_title}")
    end
  end

  describe "GET /about" do
    it "about ページが表示される" do
      get about_path
      # レスポンス
      expect(response).to have_http_status(:success)
      # タイトル
      title_text = get_title_text(response)
      expect(title_text).to eq("About | #{base_title}")
    end
  end

  describe "GET /contact" do
    it "contact ページが表示される" do
      get contact_path
      # レスポンス
      expect(response).to have_http_status(:success)
      # タイトル
      title_text = get_title_text(response)
      expect(title_text).to eq("Contact | #{base_title}")
    end
  end
end
