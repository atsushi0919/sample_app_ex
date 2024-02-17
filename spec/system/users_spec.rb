RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "#create" do
    context "無効な値の場合" do
      it "エラーメッセージが表示される" do
        visit signup_path
        fill_in I18n.t("common.name"), with: ""
        fill_in I18n.t("common.email"), with: "user@invlid"
        fill_in I18n.t("common.password"), with: "foo"
        fill_in I18n.t("common.password_confirmation"), with: "bar"
        click_button "アカウントを登録する"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.field_with_errors"
      end
    end
  end
end
