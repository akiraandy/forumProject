# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  after(:each) do
    session[:user_id] = nil
  end

  describe "GET index" do
    it "requires user to access" do
      get :index
      expect(response).to have_http_status(302)
    end

    it "successful on user login" do
      sign_in_user
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET show" do
    it "will return a 404 if resource does not exist" do
      sign_in_user
      get :show, params: { id: 1000 }
      expect(response).to have_http_status(404)
    end

    it "will return a 200 if resource is found" do
      sign_in_user
      category = create(:category)
      get :show, params: { id: category.id }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET new" do
    it "does not allow regular user access" do
      sign_in_user
      get :new
      expect(response).to have_http_status(401)
    end

    it "allows mod access" do
      sign_in_mod
      get :new
      expect(response).to have_http_status(200)
    end

    it "allows admin access" do
      sign_in_admin
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "POST create" do
    it "only allows admin access" do
      sign_in_user
      post :create
      expect(response).to have_http_status(401)
    end

    it "creates a category and redirects to category" do
      sign_in_admin
      post :create, params: { category: { name: "javaScript" } }
      expect(response).to redirect_to(assigns(:category))
    end

    it "will render new upon invalid params" do
      sign_in_admin
      post :create, params: { category: { name: "tooLongForValidCategory" * 20 } }
      expect(response).to render_template(:new)
    end
  end
end
