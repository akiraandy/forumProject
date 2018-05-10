# frozen_string_literal: true

module CommentsControllerHelper
  def can_edit!
    comment = Comment.find(params[:id])
    render file: "public/401.html", status: :unauthorized unless current_user.comments.include?(comment) || current_user.admin || current_user.mod
  end

  def not_flagged
    comment = Comment.find(params[:id])
    render file: "public/401.html", status: :unauthorized unless !comment.mod_flag || current_user.admin || current_user.mod
  end

  def not_destroyed
    comment = Comment.find(params[:id])
    render file: "public/401.html", status: :unauthorized unless !comment.deleted || current_user.admin || current_user.mod
  end
end
