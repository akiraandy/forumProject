require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    describe "GET show" do
        before(:each) do
            @question = create(:question)
        end
        it "should only allow user access" do
            get :show, params: {category_id: @question.category_id, id: @question.id}
            expect(response).to redirect_to(root_path)
        end

        it "displays question succesfully" do
            sign_in_user
            get :show, params: {category_id: @question.category_id, id: @question.id}
            expect(response).to have_http_status(200)
            expect(response).to render_template(:show)
        end
    end

    describe "GET new" do
        it "should only allow user access" do
            category = create(:category)
            get :new, params: {category_id: category.id}
            expect(response).to redirect_to(root_path)
        end

        it "should return 200 on success" do
            sign_in_user
            category = create(:category)
            get :new, params: {category_id: category.id}
            expect(response).to have_http_status(200)
        end
    end

    describe "POST create" do
        let(:category) { create(:category) }
        let(:question) { create(:question) }

        it "should only allow user access" do
            post :create, params: {category_id: category.id, category: {title: question.title, body: question.body}}
            expect(response).to redirect_to(root_path)
        end

        it "redirects to question upon successful creation" do
            sign_in_user
            post :create, params: {category_id: category.id, question: {title: question.title, body: question.body } }
            expect(response).to redirect_to(category_question_url(category, assigns(:question)))
        end

        it "renders new if invalid data received" do
            sign_in_user
            post :create, params: {category_id: category.id, question: {title: question.title, body: question.body } }
            expect(response).to redirect_to(category_question_url(category, assigns(:question)))
            
        end
    end
end
