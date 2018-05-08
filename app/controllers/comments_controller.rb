# frozen_string_literal: true

class CommentsController < ApplicationController
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

    private
      def comment_params
        params.require(:comment).permit(:body)
      end
end
