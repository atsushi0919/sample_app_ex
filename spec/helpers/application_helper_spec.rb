require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "full title helper" do
    let(:base_title) {"Ruby on Rails Tutorial Sample App"}

      it "引数の文字列ありなら 文字列+ベースタイトル が返る" do
        expect(full_title("HogeHoge")).to eq "HogeHoge | #{base_title}"
      end
      it "引数なしなら ベースタイトル が返る" do
        expect(full_title).to eq "#{base_title}"
      end
  end
end
