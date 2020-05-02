# frozen_string_literal: true

require "utils/auth0"
require File.expand_path("../support/climate_control_helpers", __dir__)

RSpec.describe Utils::Auth0 do
  include ClimateControlHelpers

  around do |example|
    with_modified_env("AUTH0_DOMAIN" => "auth0-domain", "AUTH0_CLIENT_ID" => "auth0-client-id") do
      example.run
    end
  end

  describe ".logout_url" do
    it "generates an auth0 logout url" do
      logout_url = described_class.logout_url(redirect_to: "https://www.example.com")
      expect(logout_url.to_s).to eq "https://auth0-domain/v2/logout?returnTo=https%3A%2F%2Fwww.example.com&client_id=auth0-client-id"
    end
  end
end
