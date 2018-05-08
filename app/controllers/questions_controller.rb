class QuestionsController < ApplicationController
    before_action :authorize!

    def show
        @question = Question.find(params[:id])
    end

    def new
        @question = Question.new
    end

    def create
        @category = Category.find(params[:category_id])
        @question = Question.new(question_params) 
        @question.attributes = {user: current_user, category: @category}
        if @question.save
            redirect_to category_question_url(@category, @question)
        else
            render "new"
        end
    end

    private

    def question_params
        params.require(:question).permit(:title, :body)
    end
end