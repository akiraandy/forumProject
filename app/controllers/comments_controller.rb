# frozen_string_literal: true

class CommentsController < ApplicationController
  include CommentsControllerHelper
  before_action :can_edit!, only: :update
  before_action :authorize!

  def create
    @comment = Comment.new(comment_params)
    @question = Question.find(params[:question_id])
    @comment.attributes = { user: current_user, question: @question }
    if @comment.save
      redirect_to question_path(@question)
    else
      render "new"
    end
  end

  def new
    @question = Question.find(params[:question_id])
    @comment = Comment.new
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.assign_attributes(comment_params)
    if @comment.body_changed?
      @comment.update(edited: true)
    end
    if @comment.save
      redirect_to question_path(@comment.question)
    else
      render :edit, status: 422
    end
  end

    private
      def comment_params
        params.require(:comment).permit(:body, :edited, :deleted, :mod_flag)
      end
end
