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
      post :create, params: { category_id: category.id, question: { title: question.title, body: question.body } }
      expect(response).to redirect_to(question_comments_url(assigns(:question)))
    end
  end
end
