# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET index" do
    it "will not allow regular users access" do
      sign_in_user
      get :index
      expect(response).to have_http_status(401)
    end

    it "will not allow mods access" do
      sign_in_mod
      get :index
      expect(response).to have_http_status(401)
    end

    it "will only allow admin access" do
      sign_in_admin
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT update" do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }
    let(:mod) { create(:mod) }

    it "will not allow regular users access" do
      sign_in_user
      put :update, params: { id: user.id }
      expect(response).to have_http_status(401)
    end

    it "will not allow mods access" do
      sign_in_mod
      put :update, params: { id: user.id }
      expect(response).to have_http_status(401)
    end

    it "will only allow admin access" do
      sign_in_admin
      put :update, params: { id: user.id, user: { mod: user.mod, admin: user.admin } }
      expect(response).to have_http_status(302)
    end

    it "will promote user to mod" do
      sign_in_admin
      expect(user.mod).to eq false
      put :update, params: { id: user.id, user: { mod: true } }
      expect(user.reload.mod).to eq true
    end

    it "will promote user to admin" do
      sign_in_admin
      expect(user.mod).to eq false
      put :update, params: { id: user.id, user: { admin: true } }
      expect(user.reload.admin).to eq true
    end

    it "will demote admin to regular user" do
      sign_in_admin
      expect(admin.admin).to eq true
      put :update, params: { id: admin.id, user: { admin: false } }
      expect(admin.reload.admin).to eq false
    end

    it "will demote mod to regular user" do
      sign_in_admin
      expect(mod.mod).to eq true
      put :update, params: { id: mod.id, user: { mod: false } }
      expect(mod.reload.mod).to eq false
    end
  end
end
