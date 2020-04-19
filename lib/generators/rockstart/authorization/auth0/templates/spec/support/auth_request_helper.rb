# frozen_string_literal: true

# Helpers for Auth0 with request specs
module AuthRequestHelper
  def self.included(base)
    base.before(:all) do
      OmniAuth.config.test_mode = true
    end
    base.after(:each) do
      OmniAuth.config.mock_auth[:auth0] = nil
    end
  end

  def sign_in(resource)
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(resource.to_h)
    post "/auth/auth0"
    follow_redirect! # call the callback endpoint
  end

  def sign_out(_resource)
    delete auth_sign_out_path
  end
end

RSpec.configure do |config|
  config.include AuthRequestHelper, type: :request
end
