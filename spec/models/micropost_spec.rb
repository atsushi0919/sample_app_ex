require "rails_helper"

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(content: "Lorem ipsum") }

  it "有効な micropost" do
    expect(micropost).to be_valid
  end

  it "user_id がないときは有効にならない" do
    micropost.user_id = nil
    expect(micropost).to_not be_valid
  end

  it "content が空のときは有効にならない" do
    micropost.content = "   "
    expect(micropost).to_not be_valid
  end

  it "content が 140 文字を超えるときは有効にならない" do
    micropost.content = "a" * 141
    expect(micropost).to_not be_valid
  end

  it "並び順が投稿の新しい順になっている" do
    send(:user_with_posts)
    expect(create(:most_recent)).to eq Micropost.first
    pp Micropost.all
  end

  it "投稿したユーザが削除されたとき、そのユーザのMicropostも削除される" do
    post = create(:most_recent)
    user = post.user
    expect do
      user.destroy
    end.to change(Micropost, :count).by(-1)
  end
end
