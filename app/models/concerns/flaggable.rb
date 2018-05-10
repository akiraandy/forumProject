# frozen_string_literal: true

module Flaggable
  def content
    if self[:mod_flag]
      "Content has been flagged"
    elsif self[:deleted]
      "[Deleted]"
    else
      self[:body]
    end
  end
end
