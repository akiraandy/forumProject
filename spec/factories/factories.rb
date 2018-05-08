FactoryBot.define do
  factory :user do
    provider "Google"
    uid  "test"
    name "testUser"
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
    name "testCategory"
  end
end
