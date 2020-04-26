# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"

class Rockstart::RunGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers
  include Rockstart::Generators::ContentSecurityOptions

  all_class_options

  def setup_development_environment
    generate "rockstart:development", devise_option, pundit_option, rollbar_option
  end

  def generate_testing
    generate "rockstart:testing", devise_option
  end

  def generate_storage
    generate "rockstart:database", memcached_option, postgres_option
  end

  def generate_mailers
    generate "rockstart:mailers"
  end

  def generate_frontend_app
    generate "rockstart:frontend_app"
  end

  def generate_authorization
    generate "rockstart:authorization", devise_option, pundit_option
  end

  def generate_monitoring
    generate "rockstart:monitoring", rollbar_option, memcached_option
  end

  def generate_security
    generate "rockstart:security", devise_option, *content_security_options
  end

  def generate_deployment
    generate "rockstart:deployment",
             devise_option,
             memcached_option,
             postgres_option,
             rollbar_option
  end

  def generate_quality
    generate "rockstart:quality"
  end
end