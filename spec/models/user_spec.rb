require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "バリデーション" do
    context "データが条件を満たすとき" do
      it "保存できる" do
        expect(user).to be_valid
      end
    end
    context "name が空のとき" do
      it "エラーが発生する" do
        user.name = "   "
        expect(user).to_not be_valid
        # エラーメッセージチェック用
        # expect(user.errors.messages[:name]).to include "を入力してください"
      end
    end
    context "name が 51 文字以上のとき" do
      it "エラーが発生する" do
        user.name = "a" * 51
        expect(user).to_not be_valid
      end
    end

    context "email が空のとき" do
      it "エラーが発生する" do
        user.email = "   "
        expect(user).to_not be_valid
        # expect(user.errors.messages[:email]).to include "を入力してください"
      end
    end
    context "email が 256 文字以上のとき" do
      it "エラーが発生する" do
        user.email = "#{'a' * 247}@test.com"
        expect(user).to_not be_valid
      end
    end
    context "email が有効な形式のとき" do
      it "保存できる" do
        valid_addresses =
          %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
    context "email が無効な形式のとき" do
      it "エラーが発生する" do
        invalid_addresses =
          %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to_not be_valid
        end
      end
    end

    context "email が重複したとき" do
      it "エラーが発生する" do
        duplicate_user = user.dup
        user.save
        expect(duplicate_user).to_not be_valid
      end
    end

    context "email に大文字が含まれているとき" do
      it "小文字に変換して保存する" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        user.email = mixed_case_email
        user.save
        expect(user.reload.email).to eq mixed_case_email.downcase
      end
    end

    context "password が空のとき" do
      it "エラーが発生する" do
        user.password = user.password_confirmation = " " * 8
        expect(user).to_not be_valid
      end
    end

    context "password が 7 文字以下のとき" do
      it "エラーが発生する" do
        user.password = user.password_confirmation = "a" * 7
        expect(user).to_not be_valid
      end
    end
  end

  describe "#authenticated?" do
    context "digest が nil のとき" do
      it "false を返す" do
        expect(user.authenticated?(:remember, "")).to be_falsy
      end
    end
  end

  describe "#follow and #unfollow" do
   let(:user) { create(:user, :archer) }
   let(:other) { create(:user, :lana) }

   it "follow すると following? が true になる" do
     expect(user.following?(other)).to_not be_truthy
     user.follow(other)
     expect(other.followers.include?(user)).to be_truthy
     expect(user.following?(other)).to be_truthy
   end

   it "unfollow すると following? が false になる" do
     user.follow(other)
     expect(user.following?(other)).to_not be_falsey
     user.unfollow(other)
     expect(user.following?(other)).to be_falsey
   end

   it "自分を follow 出来ない" do
    user.follow(user)
    expect(user.following?(user)).to be_falsey
  end
 end
end
