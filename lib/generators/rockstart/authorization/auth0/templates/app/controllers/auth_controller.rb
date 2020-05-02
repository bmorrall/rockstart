# frozen_string_literal: true

require "utils/auth0"

# Omniauth Controller for Auth0
class AuthController < ApplicationController
  # GET /auth/sign_in
  def new
    if user_signed_in?
      redirect_to url_for_user_dashboard
    else
      render :new
    end
  end

  # GET /auth/sign_out
  def sign_out
    if user_signed_in?
      redirect_to url_for_user_dashboard
    else
      render :sign_out
    end
  end

  # DELETE /auth/sign_out
  def destroy
    reset_session
    redirect_to Utils::Auth0.logout_url(redirect_to: auth_sign_out_url).to_s
  end

  # GET /callback
  def callback
    # This stores all the user information that came from Auth0 and the IdP
    session[:userinfo] = request.env["omniauth.auth"].slice(:provider, :uid, :info)

    # Redirect to the URL you want after successful auth
    redirect_to url_for_user_dashboard
  end

  # GET /auth/failure
  def failure
    # show a failure page or redirect to an error page
    error_key = params[:message].to_s.gsub(/[^\w-]/, "").presence || "generic"
    error_message = t(error_key, scope: "auth0.omniauth_error", default: :generic)
    redirect_to auth_sign_in_path, alert: error_message
  end
end
