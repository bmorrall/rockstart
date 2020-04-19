# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::AuthorizationGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  auth0_class_option
  devise_class_option
  pundit_class_option

  def generate_auth0
    return unless auth0?

    generate "rockstart:authorization:auth0"
  end

  def generate_devise
    return unless devise?

    generate "rockstart:authorization:devise", pundit_option
  end

  def generate_pundit
    return unless pundit?

    generate "rockstart:authorization:pundit", auth0_option
  end
end
