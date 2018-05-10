# frozen_string_literal: true

class Question < ApplicationRecord
  before_update :edit_flag
  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :commenters, through: :comments, class_name: "User"

  validates_presence_of :title, :body
  validates :title, length: { maximum: 140 }
  validates :body, length: { minimum: 20 }

  private

    def edit_flag
      if self.title_changed? || self.body_changed?
        self.edited = true
      end
    end
end
