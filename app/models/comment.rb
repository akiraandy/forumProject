# frozen_string_literal: true

class Comment < ApplicationRecord
  include Flaggable
  before_update :edit_flag
  belongs_to :user
  belongs_to :question

  validates_presence_of :body

  def edit_flag
    if self.body_changed?
      self.edited = true
    end
  end
end
