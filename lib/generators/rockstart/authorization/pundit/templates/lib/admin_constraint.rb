# frozen_string_literal: true

# Constraint for limiting routes to admin users
class AdminConstraint
  def self.matches?(request)
    return false unless request.session[:userinfo].present?

    user = User.new(request.session[:userinfo])
    user&.admin?
  end
end
