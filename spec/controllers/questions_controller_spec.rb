# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  describe "GET show" do
    let(:question) { create(:question) }
    it "should only allow user access" do
      get :show, params: { category_id: question.category_id, id: question.id }
      expect(response).to redirect_to(root_path)
    end

    it "displays question succesfully" do
      sign_in_user
      get :show, params: { category_id: question.category_id, id: question.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    let(:category) { create(:category) }
    it "should only allow user access" do
      get :new, params: { category_id: category.id }
      expect(response).to redirect_to(root_path)
    end

    it "should return 200 on success" do
      sign_in_user
      get :new, params: { category_id: category.id }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    let(:category) { create(:category) }
    let(:question) { create(:question) }

    it "should only allow user access" do
      post :create, params: { category_id: category.id, category: { title: question.title, body: question.body } }
      expect(response).to redirect_to(root_path)
    end

    it "redirects to question upon successful creation" do
      sign_in_user
      post :create, params: { category_id: category.id, question: { title: question.title, body: question.body } }
      expect(response).to redirect_to(question_comments_url(assigns(:question)))
    end

    it "renders new if invalid data received" do
      sign_in_user
      post :create, params: { category_id: category.id, question: { title: "", body: question.body } }
      expect(response).to render_template("new")
      expect(response).to have_http_status(422)
    end
  end

  describe "PUT update" do
    let(:invalid_question) { create(:question) }
    let(:user) { sign_in_user_with_question }
    let(:question) { user.questions.first }

    it "regular users who did not create the question cannot access route" do
      sign_in_user
      put :update, params: { id: invalid_question.id, question: { title: "test" } }
      expect(response).to have_http_status(401)
    end

    it "mods or admins can update any question" do
      sign_in_admin
      put :update, params: { id: question.id, question: { title: "test" } }
      expect(response).to redirect_to(question_path(question))
    end

    it "can edit mod_flag" do
      expect(question.mod_flag).to eq false
      put :update, params: { id: question.id, question: { mod_flag: true } }
      expect(response).to redirect_to(question_path(question))
      expect(question.reload.mod_flag).to eq true
    end

    it "can edit body" do
      new_body = "new body who dis?" * 3
      put :update, params: { id: question.id, question: { body: new_body } }
      expect(response).to redirect_to(question_path(question))
      expect(question.reload.body).to eq new_body
    end

    it "can edit title" do
      new_title = "new title for question"
      put :update, params: { id: question.id, question: { body: new_title } }
      expect(response).to redirect_to(question_path(question))
      expect(question.reload.body).to eq new_title
    end

    it "will render show if invalid data given" do
      put :update, params: { id: question.id, question: { body: "" } }
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(422)
    end
  end
end
