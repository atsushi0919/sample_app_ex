require "rails_helper"

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
    visit login_path
  end

  describe "#new" do
    context "無効な値のとき" do
      it "flashメッセージが表示される" do
        fill_in I18n.t("common.email"), with: ""
        fill_in I18n.t("common.password"), with: ""
        click_button I18n.t("common.login")

        expect(page).to have_selector "div.alert.alert-danger"
        visit root_path
        expect(page).to_not have_selector "div.alert.alert-danger"
      end
    end

    context "有効な値のとき" do
      let(:user) { create(:user, :michael) }

      it "ログインできる" do
        post login_path, params: {
          session: { email: user.email,
                     password: user.password }
        }

        expect(response).to redirect_to(user)
      end
    end
  end
end
