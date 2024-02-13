require "rails_helper"

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
    visit root_path
  end

  describe "root" do
    it "リンクが正しく表示される root*2, help*1, about*1, contact*1" do
      expect(page).to have_link nil,       href: root_path, count: 2
      expect(page).to have_link "Help",    href: help_path
      expect(page).to have_link "About",   href: about_path
      expect(page).to have_link "Contact", href: contact_path
    end
  end
end
