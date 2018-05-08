# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates_presence_of :body
end
