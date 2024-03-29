FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  trait :michael do
    name { "Michael Example" }
    email { "michael@example.com" }
    admin { true }
  end

  trait :archer do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
  end

  trait :lana do
    name { "Lana Kane" }
    email { "hands@example.gov" }
  end

  # アクティベート前のユーザー
  trait :malory do
    name { "Malory Archer" }
    email { "boss@example.gov" }
    activated { false }
    activated_at { nil }
  end

  factory :continuous_users, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
end
