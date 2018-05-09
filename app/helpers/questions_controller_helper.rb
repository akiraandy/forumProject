# frozen_string_literal: true

module QuestionsControllerHelper
  def can_edit!
    question = Question.find(params[:id])
    render file: "public/401.html", status: :unauthorized unless current_user.questions.include?(question) || current_user.admin || current_user.mod
  end
end
