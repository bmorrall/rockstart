# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OkComputer", type: :request do
  let(:http_authorization) do
    username = OkComputer.username
    password = OkComputer.password
    ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end

  describe "GET /health" do
    it "responds with success", :aggregate_failures do
      get "/health"
      expect(response.body).to have_content("success")
      expect(response.body).not_to have_content("failure")
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /health/all" do
    it "responds with success", :aggregate_failures do
      get "/health/all", headers: { "HTTP_AUTHORIZATION" => http_authorization }
      expect(response.body).to have_content("success")
      expect(response.body).not_to have_content("failure")
      expect(response).to have_http_status(:success)
    end

    it "requires http authorization" do
      get "/health/all"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /health/cache" do
    it "responds with success", :aggregate_failures do
      get "/health/cache", headers: { "HTTP_AUTHORIZATION" => http_authorization }
      expect(response.body).to have_content("success")
      expect(response.body).not_to have_content("failure")
      expect(response).to have_http_status(:success)
    end

    it "requires http authorization" do
      get "/health/cache"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /health/database" do
    it "responds with success", :aggregate_failures do
      get "/health/database", headers: { "HTTP_AUTHORIZATION" => http_authorization }
      expect(response.body).to have_content("success")
      expect(response.body).not_to have_content("failure")
      expect(response).to have_http_status(:success)
    end

    it "requires http authorization" do
      get "/health/database"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
