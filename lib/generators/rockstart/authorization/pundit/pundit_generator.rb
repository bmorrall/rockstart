# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Authorization
  class PunditGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    auth0_class_option

    def add_pundit_exception_handling
      application <<~PUNDIT
        # Treat Pundit authentication failures as forbidden
        config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
      PUNDIT
    end

    def add_pundit_to_application_controller
      inject_into_file "app/controllers/application_controller.rb",
                       "  include Pundit\n",
                       before: /^end$/
    end

    def add_pundit_configuration
      directory "config"
    end

    def add_prebuilt_resources
      directory "app"
      directory "lib"
      directory "spec"
    end

    def add_scaffold_templates
      copy_file "scaffold/policy.rb.tt", "lib/templates/pundit/policy/policy.rb"
      copy_file "scaffold/policy_spec.rb.tt", "lib/templates/rspec/policy/policy_spec.rb"
    end
  end
end
