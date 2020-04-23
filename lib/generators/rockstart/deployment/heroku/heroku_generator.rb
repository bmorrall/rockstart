# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Deployment
  class HerokuGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    postgres_class_option

    def create_procfile
      template "Procfile"
    end

    def create_app_json
      template "app.json"
    end

    def add_deploy_script
      script_template "deploy-heroku"
    end
  end
end
