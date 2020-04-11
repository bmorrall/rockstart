# frozen_string_literal: true

class Rockstart::SmtpMailerGenerator < Rails::Generators::Base
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
    directory "config/initializers"
  end
end
