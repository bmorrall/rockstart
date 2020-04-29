# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"
require "rockstart/generators/template_helpers"

module Rockstart::Security
  class ContentSecurityGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::ContentSecurityOptions
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    class_option :session_name, type: :string,
                                desc: "Name used for Rails Sessions",
                                default: Rockstart::Env.default_session_name

    rollbar_class_option

    def add_initializer
      initializer_template "content_security_policy"
    end

    def configure_session_store
      initializer_template "session_store"
    end

    def add_csp_violations_controller
      template "csp_violations_controller.rb.tt", "app/controllers/csp_violations_controller.rb"
      route "resources :csp_violations, only: [:create]"
      template "content_security_spec.rb.tt", "spec/requests/content_security_spec.rb"
    end

    private

    def session_name
      options[:session_name]
    end
  end
end
