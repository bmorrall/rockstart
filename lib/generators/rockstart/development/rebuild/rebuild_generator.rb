# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"
require "rockstart/generators/template_helpers"

module Rockstart::Development
  class RebuildGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::ContentSecurityOptions
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option
    postgres_class_option
    pundit_class_option
    rollbar_class_option

    def add_rocstart_script
      script_template "rockstart"
    end
  end
end
