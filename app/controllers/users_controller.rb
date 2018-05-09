# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :admin!

  def index
    @users = User.all.where("id != #{current_user.id}")
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_attributes)
    @user.save
    redirect_to users_path
  end

    private

      def user_attributes
        params.require(:user).permit(:admin, :mod)
      end
end
