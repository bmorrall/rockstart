# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Deployment
  class HerokuGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    class_option :free_tier, type: :boolean,
                 desc: "Prioritizes configratons and addons for the free tier",
                 default: true

    auth0_class_option
    memcached_class_option
    postgres_class_option
    rollbar_class_option
    sidekiq_class_option

    def create_procfile
      template "Procfile"
    end

    def create_app_json
      template "app.json"
    end

    def add_rack_task
      template "heroku.rake", "lib/tasks/heroku.rake"
    end

    def add_deploy_script
      script_template "deploy-heroku"
    end

    private

    def free_tier?
      options.fetch(:free_tier)
    end
  end
end
