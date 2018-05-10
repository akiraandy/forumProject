# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider "Google"
    uid "test"
    sequence(:name) { |n| "name_#{n}" }
    oauth_token "token"
    oauth_expires_at 15.minutes.from_now
    admin false
    mod false
    factory :user_with_question do
      after :create do |question|
    create(:question, user: question)
  end
    end
    factory :user_with_comment do
      after :create do |comment|
        create(:comment, user: comment)
      end
    end
  end


  factory :admin, class: User do
    provider "Google"
    uid "test"
    sequence(:name) { |n| "admin_#{n}" }
    oauth_token "token"
    oauth_expires_at 15.minutes.from_now
    admin true
    mod true
  end

  factory :mod, class: User do
    provider "Google"
    uid "test"
    sequence(:name) { |n| "mod_#{n}" }
    oauth_token "token"
    oauth_expires_at 15.minutes.from_now
    admin false
    mod true
  end

  factory :category do
    sequence(:name) { |n| "cat_#{n}" }
  end

  factory :question do
    sequence(:title) { |n| "title_#{n}" }
    body "testBody" * 5
    user
    category
    mod_flag false
    deleted false
    edited false
    factory :question_with_deleted_comment do
      after :create do |comment|
        create(:comment, question: comment, deleted: true)
      end
    end
    factory :question_with_flagged_comment do
      after :create do |comment|
        create(:comment, question: comment, mod_flag: true)
      end
    end

    factory :deleted_question do
      after :create do |deleted_question|
          deleted_question.deleted = true
        end
    end
    factory :flagged_question do
      after :create do |flagged_question|
          flagged_question.mod_flag = true
        end
    end
  end


  factory :comment do
    body "commentTestBody" * 5
    user
    question
    edited false
    deleted false
    mod_flag false
    factory :deleted_comment do
      deleted true
    end

    factory :flagged_comment do
      mod_flag true
    end
  end
end
