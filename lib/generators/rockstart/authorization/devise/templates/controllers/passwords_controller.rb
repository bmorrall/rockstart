# frozen_string_literal: true

# Updated Passwords Controller provided by rockstart
class Users::PasswordsController < Devise::PasswordsController
  # Store reset token in session so that it is not in Referer
  before_action :move_reset_token_to_session, only: [:edit]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
    resource.reset_password_token = session[:reset_password_token]
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  def move_reset_token_to_session
    token = params.delete(:reset_password_token)
    return unless token

    session[:reset_password_token] = token
    redirect_to edit_password_path(resource_class.new)
  end

  def assert_reset_token_passed
    session[:reset_password_token].blank? && super
  end

  def sign_in(resource_name, resource)
    session.delete(:reset_password_token)
    super
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
