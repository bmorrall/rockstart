# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "GET /auth/sign_in" do
    context "as a guest" do
      it "renders a login form" do
        get "/auth/sign_in"
        expect(response).to have_http_status(:success)
      end
    end

    context "as an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "redirects to the dashboard" do
        get "/auth/sign_in"
        expect(response).to redirect_to url_for_user_dashboard
      end
    end
  end

  describe "GET /auth/sign_out" do
    it "renders a thanks for visiting page" do
      get "/auth/sign_out"
      expect(response).to have_http_status(:success)
    end

    context "as an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "redirects to the dashboard" do
        get "/auth/sign_out"
        expect(response).to redirect_to url_for_user_dashboard
      end
    end
  end

  describe "POST /auth/auth0" do
    context "with a generic error" do
      before do
        OmniAuth.config.mock_auth[:auth0] = :something_went_wrong
      end

      it "renders a failure page" do
        post "/auth/auth0"
        expect(response).to redirect_to("/callback")

        follow_redirect!
        expect(response).to redirect_to "/auth/failure?message=something_went_wrong&strategy=auth0"

        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to have_content(t("auth0.omniauth_error.generic"))
      end
    end
  end

  describe "DELETE /auth/sign_out" do
    context "as an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "redirects back to the auth0 logout page with a redirect to the sign out page" do
        delete "/auth/sign_out"

        url_for_sign_out = CGI.escape(auth_sign_out_url)
        expect(response).to redirect_to(
          "https://auth0-domain/v2/logout?returnTo=#{url_for_sign_out}&client_id=auth0-client-id"
        )
      end

      it "signs out the user" do
        delete "/auth/sign_out"
        expect(controller).not_to be_user_signed_in
        expect(controller.current_user).not_to be_persisted
      end
    end
  end
end
