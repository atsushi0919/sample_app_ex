FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
  end

  trait :michael do
    name { "Michael Example" }
    email { "michael@example.com" }
  end

  trait :archer do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
  end
end
