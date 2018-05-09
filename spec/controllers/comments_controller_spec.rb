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
  end
end
