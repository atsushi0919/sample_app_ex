PASSWORD = "password"
# メインのサンプルユーザーを1人作成する
User.create!(name:  "管理 太郎",
             email: "example@railstutorial.org",
             password:              PASSWORD,
             password_confirmation: PASSWORD)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(name:  name,
               email: email,
               password:              PASSWORD,
               password_confirmation: PASSWORD)
end
