# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authorize!
  before_action :admin_or_mod!, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
    @category = Category.find_by(id: params[:id])
    if !@category
      render file: "public/404.html", status: :not_found
    end
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
