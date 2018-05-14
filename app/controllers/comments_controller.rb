# frozen_string_literal: true

class CommentsController < ApplicationController
  include CommentsControllerHelper
  before_action :can_edit!, only: [:update, :edit, :destroy]
  before_action :not_flagged, only: [:edit]
  before_action :not_destroyed, only: [:edit, :destroy]
  before_action :authorize!

  def create
    @comment = Comment.new(comment_params)
    @question = Question.find(params[:question_id])
    @comment.attributes = { user: current_user, question: @question }
    if @comment.save
      redirect_to question_path(@question)
    else
      render :new, status: 422
    end
  end

  def new
    @question = Question.find_by(id: params[:question_id])
    @comment = Comment.new
    if !@question
      render file: "public/404.html", status: :not_found
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    if !@comment
      render file: "public/404.html", status: :not_found
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to question_path(@comment.question)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.update(deleted: true)
    redirect_to question_path(@comment.question)
  end

    private
      def comment_params
        params.require(:comment).permit(:body, :edited, :deleted, :mod_flag)
      end
end
