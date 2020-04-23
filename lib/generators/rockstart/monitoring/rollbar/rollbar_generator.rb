# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Monitoring
  class RollbarGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    auth0_class_option
    sidekiq_class_option

    def add_initializer
      initializer_template "rollbar"
    end
  end
end
