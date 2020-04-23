# frozen_string_literal: true

# Updated Registrations Controller provided by rockstart
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: %i[create]
  before_action :configure_account_update_params, only: %i[update]

  # GET /users/sign_up
  # def new
  #   super
  # end

  # POST /users
  # def create
  #   super
  # end

  # GET /users/edit
  # def edit
  #   super
  # end

  # PUT /users
  # def update
  #   super
  # end

  # DELETE /users
  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /users/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  # The path used after deleting account
  def after_sign_out_path_for(_resource)
    new_user_registration_path
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # Allow the user to edit their account without providing a password
  def update_resource(resource, params)
    if account_update_params[:password].blank?
      resource.update_without_password(params)
    else
      super
    end
  end

  def account_update_params
    super.tap do |params|
      # Ensure password confirmation is included with password
      params[:password_confirmation] ||= "" if params[:password].present?
    end
  end
end
