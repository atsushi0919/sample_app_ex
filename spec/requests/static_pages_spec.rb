require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "home ページが表示される" do
      get static_pages_home_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /help" do
    it "help ページが表示される" do
      get static_pages_help_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "about ページが表示される" do
      get static_pages_about_url
      expect(response).to have_http_status(:success)
    end
  end
end
