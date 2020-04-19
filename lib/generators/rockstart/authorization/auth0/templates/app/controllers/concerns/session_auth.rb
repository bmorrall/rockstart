# frozen_string_literal: true

# Provides methods for Authenticating via a Rails session
module SessionAuth
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def current_user
    User.new(session[:userinfo])
  end

  def user_signed_in?
    session[:userinfo].present?
  end

  def authenticate_user!
    redirect_to url_for_authentication unless user_signed_in?
  end
end
