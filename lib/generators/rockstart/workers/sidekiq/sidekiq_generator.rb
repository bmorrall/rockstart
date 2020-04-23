# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/system_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Workers
  class SidekiqGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::SystemHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option
    rollbar_class_option

    def add_initializer
      copy_initializer "sidekiq"
    end

    def add_configuration
      template "sidekiq.yml", "config/sidekiq.yml"
    end

    def configure_active_job
      application "config.active_job.queue_adapter = :sidekiq\n"
    end
  end
end
