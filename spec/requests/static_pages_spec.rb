require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  def get_title_text(response)
    Nokogiri::HTML(response.body).css("title").text
  end

  describe "GET root" do
    it "home ページが表示される" do
      get root_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      title_text = get_title_text(response)
      expect(title_text).to eq(base_title)
    end
  end

  describe "GET /home" do
    it "home ページが表示される" do
      get static_pages_home_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = get_title_text(response)
      expect(title_text).to eq(base_title)
    end
  end

  describe "GET /help" do
    it "help ページが表示される" do
      get static_pages_help_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = get_title_text(response)
      expect(title_text).to eq("Help | #{base_title}")
    end
  end

  describe "GET /about" do
    it "about ページが表示される" do
      get static_pages_about_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = get_title_text(response)
      expect(title_text).to eq("About | #{base_title}")
    end
  end

  describe "GET /contact" do
    it "contact ページが表示される" do
      get static_pages_contact_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = get_title_text(response)
      expect(title_text).to eq("Contact | #{base_title}")
    end
  end
end
