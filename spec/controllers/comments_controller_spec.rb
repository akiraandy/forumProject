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
end
