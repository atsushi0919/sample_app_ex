FactoryBot.define do
  factory :orange, class: Micropost do
    content { "I just ate an orange!" }
    created_at { 10.minutes.ago }
  end

  factory :most_recent, class: Micropost do
    content { "Writing a short test" }
    created_at { Time.zone.now }
    user { association :user, email: "recent@example.com" }
  end

  factory :micropost do
    sequence(:content) { Faker::Lorem.sentence(word_count: 5) }
    created_at { 42.days.ago }
    user { User.find_by(name: "michael") || association(:user, name: "michael") }
  end
end

def user_with_posts(posts_count: 5)
  create(:user) do |user|
    create_list(:orange, posts_count, user:)
  end
end
