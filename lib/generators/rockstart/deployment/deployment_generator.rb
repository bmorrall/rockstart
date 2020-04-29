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
  sidekiq_class_option

  def create_run_scripts
    script_template "web"
    script_template "worker" if sidekiq?
  end

  def create_deployment_scripts
    script_template "hooks-postdeploy"
    script_template "hooks-release"
  end

  # rubocop:disable Metrics/MethodLength
  def add_rack_deflater
    application do
      <<~RACK_DEFLATER
        if ENV["RAILS_SERVE_STATIC_FILES"].present?
          config.middleware.insert_after ActionDispatch::Static, Rack::Deflater
        else
          config.middleware.insert_after Rack::Sendfile, Rack::Deflater
        end
      RACK_DEFLATER
    end
  end
  # rubocop:enable Metrics/MethodLength

  def add_rack_deflater_spec
    copy_file "rack_deflater_spec.rb", "spec/requests/rack_deflater_spec.rb"
  end

  def generate_nginx
    generate "rockstart:deployment:nginx"
  end

  def generate_heroku
    generate "rockstart:deployment:heroku",
             auth0_option,
             memcached_option,
             postgres_option,
             rollbar_option,
             sidekiq_option
  end

  def generate_docker
    generate "rockstart:deployment:docker",
             devise_option,
             frontend_option,
             memcached_option,
             postgres_option,
             rollbar_option,
             sidekiq_option
  end
end
