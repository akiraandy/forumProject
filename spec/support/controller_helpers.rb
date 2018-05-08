module ControllerHelpers
    def sign_in_user
        session[:user_id] = create(:user).id
    end

    def sign_in_admin
        session[:user_id] = create(:admin).id
    end
end