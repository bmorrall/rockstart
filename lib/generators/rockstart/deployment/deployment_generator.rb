# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

class Rockstart::DeploymentGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers
  include Rockstart::Generators::TemplateHelpers

  source_root File.expand_path("templates", __dir__)

  auth0_class_option
  devise_class_option
  frontend_class_option
  memcached_class_option
  postgres_class_option
  rollbar_class_option

  def create_deployment_scripts
    script_template "setup-deployment"
    script_template "deployment"
  end

  def generate_nginx
    generate "rockstart:deployment:nginx"
  end

  def generate_heroku
    generate "rockstart:deployment:heroku",
             auth0_option,
             memcached_option,
             postgres_option,
             rollbar_option
  end

  def generate_docker
    generate "rockstart:deployment:docker",
             devise_option,
             frontend_option,
             memcached_option,
             postgres_option,
             rollbar_option
  end
end
