# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions
  has_many :comments
  has_many :comments_in_thread, through: :questions, class_name: "Comment"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
