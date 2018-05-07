class Question < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :commenters, through: :comments, class_name: 'User'

  validates_presence_of :title
  validates :title, length: { maximum: 30 }
end
