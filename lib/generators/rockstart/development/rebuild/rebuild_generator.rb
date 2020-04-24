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

    all_class_options

    def add_rocstart_script
      script_template "rockstart"
    end
  end
end
