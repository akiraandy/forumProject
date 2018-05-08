class CategoriesController < ApplicationController
    before_action :authorize!
    before_action :admin!, only: [:new, :create]

    def index
        @categories = Category.all
    end

    def new
        @category = Category.new
    end

    def show
        @category = params[:category_id]
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            redirect_to @category
        else
            render "new"
        end
    end

    private
    def category_params
        params.require(:category).permit(:name)
    end
end
