# frozen_string_literal: true

# Handling for any Pundit-thrown errors
module PunditErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    # e.g. I18n.t("pundit.example_policy.show?")
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default

    # redirect to the either the previous page or the default sign in page
    redirect_to(request.referrer || after_sign_in_path_for(current_user))
  end
end
