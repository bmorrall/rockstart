# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Deployment
  class HerokuGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    postgres_class_option

    def create_procfile
      template "Procfile"
    end

    def create_app_json
      template "app.json"
    end
  end
end
