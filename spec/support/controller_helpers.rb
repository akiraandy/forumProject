# frozen_string_literal: true

module ControllerHelpers
  def sign_in_user
    session[:user_id] = create(:user).id
  end

  def sign_in_admin
    session[:user_id] = create(:admin).id
  end

  def sign_in_mod
    session[:user_id] = create(:mod).id
  end

  def sign_in_user_with_question
    user = create(:user_with_question)
    session[:user_id] = user.id
    user
  end

  def sign_in_user_with_comment
    user = create(:user_with_comment)
    session[:user_id] = user.id
    user
  end
end
