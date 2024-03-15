PASSWORD = "password".freeze
# メインのサンプルユーザーを1人作成する
User.create!(name: "管理 太郎",
             email: "example@railstutorial.org",
             password: PASSWORD,
             password_confirmation: PASSWORD,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  User.create!(name:,
               email:,
               password: PASSWORD,
               password_confirmation: PASSWORD,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.microposts.create!(content:) }
end

# ユーザーフォローのリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
