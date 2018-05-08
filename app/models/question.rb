class Question < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments
  has_many :commenters, through: :comments, class_name: 'User'

  validates_presence_of :title, :body
  validates :title, length: { maximum: 30 }
  validates :body, length: { minimum: 20 }
end
