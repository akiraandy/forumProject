class Category < ApplicationRecord
    has_many :questions

    validates :name, presence: true
    validates :name, uniqueness: true
    validates :name, length: { maximum: 10 }
end
