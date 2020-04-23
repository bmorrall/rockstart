# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sidekiq", type: :request do
  describe "GET /sidekiq" do
    context "as an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "renders the sidekiq interface" do
        get "/sidekiq"
        expect(response).to have_http_status(:success)
      end
    end

    context "as an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "responds with not found" do
        expect { get "/sidekiq" }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
