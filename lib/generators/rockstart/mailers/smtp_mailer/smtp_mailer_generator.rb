# frozen_string_literal: true

require "rockstart/generators/template_helpers"

module Rockstart::Mailers
  class SmtpMailerGenerator < Rails::Generators::Base
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    def configure_test_environment
      application(nil, env: :test) do
        'config.action_mailer.default_url_options = { host: "www.example.com" }'
      end
    end

    def configure_development_environment
      application(nil, env: :development) do
        'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }'
      end
    end

    def configure_production_environment
      application(nil, env: :production) do
        <<~MAILER
          config.action_mailer.default_url_options = { host: ENV["APP_HOST"] }
          config.action_mailer.delivery_method = :smtp
        MAILER
      end
    end

    def add_initializers
      copy_initializer "action_mailer"
    end
  end
end
