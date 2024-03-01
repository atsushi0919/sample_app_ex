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
  print "\r#{n+1}/99 "
end
puts

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do |n|
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.microposts.create!(content: content) }
  print "\r#{n+1}/50 "
end
puts
