# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsControllerHelper
  before_action :authorize!
  before_action :can_edit!, only: :update

  def show
    @question = Question.find_by(id: params[:id])
    if !@question
      render file: "public/404.html", status: :not_found
    end
  end

  def edit
    @question = Question.find_by(id: params[:id])
    if !@question
      render file: "public/404.html", status: :not_found
    end
  end

  def new
    @category = Category.find_by(id: params[:category_id])
    @question = Question.new
    if !@category
      render file: "public/404.html", status: :not_found
    end
  end

  def create
    @category = Category.find_by(id: params[:category_id])
    @question = Question.new(question_params)
    @question.attributes = { user: current_user, category: @category }
    if @question.save
      redirect_to question_comments_url(@question)
    else
      render "new", status: 422
    end
  end

  def update
    @question = Question.find_by(id: params[:id])
    if @question.update(question_params)
      redirect_to question_path(@question)
    else
      render "edit", status: 422
    end
  end

    private

      def question_params
        params.require(:question).permit(:title, :body, :mod_flag)
      end
end
