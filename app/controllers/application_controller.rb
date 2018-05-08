# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize!
    if !current_user
      redirect_to root_path
    end
  end

  def admin!
    render file: "public/401.html", status: :unauthorized unless current_user.admin
  end
end
