# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Testing
  class EnvGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option
    auth0_class_option

    def add_dotenv_files
      template "dotenv.test.tt", ".env.test"
    end

    def add_climate_control_helpers
      copy_spec_support "climate_control_helpers"
    end
  end
end
