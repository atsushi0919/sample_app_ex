require 'rails_helper'

RSpec.describe "MicroPosts", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Users#show" do
    before do
      send(:user_with_posts, posts_count: 35)
      @user = Micropost.first.user
    end

    it "投稿が 30 件表示される" do
      visit user_path @user

      posts_wrapper =
        within "ol.microposts" do
          find_all("li")
        end
      expect(posts_wrapper.size).to eq 30
    end

    it "ページネーションが表示される" do
      visit user_path @user
      pagination = page.body.scan('<ul class="pagination ">').length
      expect(pagination).to eq 1
    end

    it "投稿がページ内に表示されていること" do
      visit user_path @user
      @user.microposts.page(1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end

  # describe "home" do
  #   before do
  #     send(:user_with_posts, posts_count: 35)
  #     @user = Micropost.first.user
  #     @user.password = "password"
  #     sign_in(@user)
  #     visit root_path
  #   end

  #   it "ページネーションが表示される" do
  #     pagination = page.body.scan('<ul class="pagination ">').length
  #     expect(pagination).to eq 1
  #   end

  #   context '有効な送信の場合' do
  #     it '投稿されること' do
  #       expect {
  #         fill_in 'micropost_content', with: 'This micropost really ties the room together'
  #         click_button '投稿する'
  #       }.to change(Micropost, :count).by 1

  #       expect(page).to have_content 'This micropost really ties the room together'
  #     end
  #   end

  #   context '無効な送信の場合' do
  #     it 'contentが空なら投稿されないこと' do
  #       fill_in 'micropost_content', with: ''
  #       click_button 'Post'

  #       expect(page).to have_selector 'div#error_explanation'
  #       expect(page).to have_link '2', href: '/?page=2'
  #     end
  #   end
  # end
end
