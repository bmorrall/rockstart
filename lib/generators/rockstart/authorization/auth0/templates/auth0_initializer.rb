# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV["AUTH0_CLIENT_ID"],
    ENV["AUTH0_CLIENT_SECRET"],
    ENV["AUTH0_DOMAIN"],
    callback_path: "/callback",
    authorize_params: {
      scope: "openid profile"
    }
  )
end

# Allow Omniauth to function behind a NGINX reverse proxy
OmniAuth.config.full_host = lambda do |env|
  scheme         = env["rack.url_scheme"]
  local_host     = env["HTTP_HOST"]
  forwarded_host = env["HTTP_X_FORWARDED_HOST"]
  forwarded_host.blank? ? "#{scheme}://#{local_host}" : "#{scheme}://#{forwarded_host}"
end

# Handle any failures with a failure page
OmniAuth.config.on_failure = proc do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
