# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Development
  class EnvGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option

    def add_development_dotenv
      template "dotenv.development.tt", ".env.development"
    end
  end
end
