# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :questions

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 30 }
end
