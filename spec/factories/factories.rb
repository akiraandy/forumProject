FactoryBot.define do
  factory :user do
    provider "Google"
    uid  "test"
    sequence(:name) { |n| "name_#{n}" }
    oauth_token "token"
    oauth_expires_at 15.minutes.from_now
    admin false
  end

  factory :admin, class: User do
    provider "Google"
    uid  "test"
    name "testAdmin"
    oauth_token "token"
    oauth_expires_at 15.minutes.from_now
    admin true
  end

  factory :category do
    sequence(:name) { |n| "cat_#{n}" }
  end

  factory :question do
    sequence(:title) { |n| "title_#{n}" }
    body "testBody" * 5
    user
    category
  end

  factory :comment do
      sequence(:body) { |n| "comment_#{n}" }
      user
      question
      edited false
      deleted false
      mod_flag false
  end
end
