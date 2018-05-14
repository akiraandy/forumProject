# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  describe "POST create" do
    let(:comment) { build(:comment) }
    it "requires user to access" do
      post :create, params: { question_id: comment.question_id, comment: { body: "test" } }
      expect(response).to redirect_to(root_path)
    end

    it "redirects to question after success" do
      sign_in_user
      post :create, params: { question_id: comment.question_id, comment: { body: "test" } }
      expect(response).to redirect_to(question_path(comment.question_id))
    end

    it "renders new if there is an error" do
      sign_in_user
      post :create, params: { question_id: comment.question_id, comment: { body: "" } }
      expect(response).to render_template("new")
    end
  end

  describe "GET new" do
    let(:question) { create(:question) }
    it "requires user to access" do
      get :new, params: { question_id: question.id }
      expect(response).to redirect_to(root_path)
    end

    it "should return 200 on success" do
      sign_in_user
      get :new, params: { question_id: question.id }
      expect(response).to have_http_status(200)
    end

    it "will return 404 if question does not exist" do
      sign_in_user
      get :new, params: { question_id: -1 }
      expect(response).to have_http_status(404)
    end
  end

  describe "PUT update" do
    let(:comment) { create(:comment) }
    let(:user) { sign_in_user_with_comment }
    let(:user_comment) { user.comments.first }

    it "won't allow access to regular users who did not create the comment" do
      sign_in_user
      put :update, params: { id: comment.id, comment: { body: "testing testing" } }
      expect(response).to have_http_status(401)
    end

    it "will allow mods or admins can update any question" do
      sign_in_admin
      put :update, params: { id: comment.id, comment: { body: "testBody" } }
      expect(response).to redirect_to(question_path(comment.question))
    end

    it "can edit body" do
      new_body = "new test body"
      expect(user_comment.body).to_not eq new_body
      put :update, params: { id: user_comment.id, comment: { body: new_body } }
      expect(user_comment.reload.body).to eq new_body
    end

    it "can edit mod_flag" do
      expect(user_comment.mod_flag).to eq false
      put :update, params: { id: user_comment.id, comment: { mod_flag: true } }
      expect(user_comment.reload.mod_flag).to eq true
    end

    it "can edit edited" do
      expect(user_comment.edited).to eq false
      put :update, params: { id: user_comment.id, comment: { edited: true } }
      expect(user_comment.reload.edited).to eq true
    end

    it "can edit deleted" do
      expect(user_comment.deleted).to eq false
      put :update, params: { id: user_comment.id, comment: { deleted: true } }
      expect(user_comment.reload.deleted).to eq true
    end

    it "renders edit if invalid data is given" do
      put :update, params: { id: user_comment.id, comment: { body: "" } }
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(422)
    end

    it "will turn on the edit flag if body changed" do
      put :update, params: { id: user_comment.id, comment: { body: "body change! Test test test" } }
      expect(user_comment.reload.edited).to eq true
    end

    it "will not turn on the edit flag if another attribute besides the body changed" do
      put :update, params: { id: user_comment.id, comment: { mod_flag: true } }
      expect(user_comment.reload.edited).to eq false
    end
  end

  describe "GET edit" do
    let(:comment) { create(:comment) }
    let(:flagged_comment) { create(:flagged_comment) }
    let(:deleted_comment) { create(:deleted_comment) }
    let(:user) { sign_in_user_with_comment }
    let(:user_comment) { user.comments.first }

    it "won't allow access to regular users who did not create the comment" do
      sign_in_user
      get :edit, params: { id: comment.id }
      expect(response).to have_http_status(401)
    end

    it "will allow access to the owner of the comment" do
       get :edit, params: { id: user_comment.id }
       expect(response).to have_http_status(200)
     end

    it "will allow admin access" do
      sign_in_admin
      get :edit, params: { id: user_comment.id }
      expect(response).to have_http_status(200)
    end

    it "will allow mod access" do
      sign_in_mod
      get :edit, params: { id: user_comment.id }
      expect(response).to have_http_status(200)
    end

    it "won't allow access if comment has been flagged" do
      session[:user_id] = flagged_comment.user.id
      get :edit, params: { id: flagged_comment.id }
      expect(response).to have_http_status(401)
    end

    it "will allow access to mods and admins if the content has been flagged" do
      sign_in_admin
      get :edit, params: { id: flagged_comment.id }
      expect(response).to have_http_status(200)
      sign_in_mod
      get :edit, params: { id: flagged_comment.id }
      expect(response).to have_http_status(200)
    end

    it "won't allow access if comment has been destroyed" do
      session[:user_id] = deleted_comment.user.id
      get :edit, params: { id: deleted_comment.id }
      expect(response).to have_http_status(401)
    end

    it "will allow access to mods and admins if the content has been deleted" do
      sign_in_admin
      get :edit, params: { id: deleted_comment.id }
      expect(response).to have_http_status(200)
      sign_in_mod
      get :edit, params: { id: deleted_comment.id }
      expect(response).to have_http_status(200)
    end

    it "renders edit" do
      get :edit, params: { id: user_comment.id }
      expect(response).to render_template(:edit)
    end

    it "returns a 404 if resource does not exist" do
      sign_in_admin
      get :edit, params: { id: -1000 }
      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE destroy" do
    let(:comment) { create(:comment) }
    let(:user) { sign_in_user_with_comment }
    let(:user_comment) { user.comments.first }

    it "won't allow access to regular users who did not create the comment" do
      sign_in_user
      delete :destroy, params: { id: comment.id }
      expect(response).to have_http_status(401)
    end

    it "will allow access to the owner of the comment" do
      delete :destroy, params: { id: user_comment.id }
      expect(response).to redirect_to(question_path(user_comment.question))
    end

    it "allows admin access" do
      sign_in_admin
      delete :destroy, params: { id: user_comment.id }
      expect(response).to redirect_to(question_path(user_comment.question))
    end

    it "allows mod access" do
      sign_in_mod
      delete :destroy, params: { id: user_comment.id }
      expect(response).to redirect_to(question_path(user_comment.question))
    end

    it "sets the deleted flag to true on comment" do
      expect(user_comment.deleted).to eq false
      delete :destroy, params: { id: user_comment.id }
      expect(user_comment.reload.deleted).to eq true
    end
  end
end
