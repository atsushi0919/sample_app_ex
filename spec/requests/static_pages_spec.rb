require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "GET root" do
    it "home ページが表示される" do
      get root_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = "Home | #{base_title}"
      expect(response.body).to include(title_text)
    end
  end

  describe "GET /home" do
    it "home ページが表示される" do
      get static_pages_home_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = "Home | #{base_title}"
      expect(response.body).to include(title_text)
    end
  end

  describe "GET /help" do
    it "help ページが表示される" do
      get static_pages_help_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = "Help | #{base_title}"
      expect(response.body).to include(title_text)
    end
  end

  describe "GET /about" do
    it "about ページが表示される" do
      get static_pages_about_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = "About | #{base_title}"
      expect(response.body).to include(title_text)
    end
  end

  describe "GET /contact" do
    it "contact ページが表示される" do
      get static_pages_contact_url
      # レスポンスが成功したか？
      expect(response).to have_http_status(:success)
      # タイトルの表示が適当か？
      title_text = "Contact | #{base_title}"
      expect(response.body).to include(title_text)
    end
  end
end
