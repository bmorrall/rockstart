# frozen_string_literal: true

require "rockstart/generators/system_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Monitoring
  class RollbarGenerator < Rails::Generators::Base
    include Rockstart::Generators::SystemHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    def add_rollback_gem
      gem "rollbar"

      bundle_install
    end

    def add_initializer
      copy_initializer "rollbar"
    end
  end
end
