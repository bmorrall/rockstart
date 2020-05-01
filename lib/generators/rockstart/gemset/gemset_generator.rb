# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"
require "rockstart/generators/system_helpers"

class Rockstart::GemsetGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers
  include Rockstart::Generators::ContentSecurityOptions
  include Rockstart::Generators::SystemHelpers

  all_class_options

  def install_gems
    gem "namae"
  end

  def install_auth0_gems
    return unless auth0?

    gem "omniauth-auth0", "~> 2.2"
    gem "omniauth-rails_csrf_protection", "~> 0.1"
  end

  def install_devise_gems
    return unless devise?

    gem "devise"
  end

  def install_memcached_gems
    return unless memcached?

    gem "dalli"
    gem "connection_pool"
  end

  def install_postgres_gems
    return unless postgres?

    gem "zero_downtime_migrations"
  end

  def install_sidekiq_gems
    return unless sidekiq?

    gem "sidekiq"
  end

  def install_pundit_gems
    return unless pundit?

    gem "pundit"
    gem "pundit-matchers", group: :test
  end

  def install_frontend_gems
    return unless frontend?

    gem "simple_form"
    gem "title", github: "calebthompson/title"
  end

  def install_development_gems
    gem "audited", "~> 4.9"
    gem "friendly_id"
  end

  def install_lograge_gems
    gem "lograge"
    gem "logstash-event"
  end

  def install_rollbar_gems
    return unless rollbar?

    gem "rollbar", "~> 2.25.0"
  end

  def install_okcomputer_gems
    gem "okcomputer"
  end

  def install_rubocop_gems
    gem "rubocop-rails", require: false, group: %i[development test]
  end

  def install_brakeman_gems
    gem "brakeman", group: %i[development test]
  end

  def install_bundler_audit_gems
    gem "bundler-audit", github: "rubysec/bundler-audit", group: %i[development test]
  end

  def install_rack_attack_gems
    gem "rack-attack"
  end

  def install_rspec_gems
    gem "capybara", ">= 2.15", group: :test
    gem "dotenv-rails", groups: %i[development test]
    gem "factory_bot_rails", group: %i[development test]
    gem "faker", group: %i[development test]
    gem "rspec-rails", "~> 4.0.0", group: %i[development test]
    gem "shoulda-matchers", group: :test
  end

  def install_simplecov_gems
    gem "simplecov", group: :test
  end

  def remove_unused_tzinfo
    comment_lines "Gemfile", /gem ['"]tzinfo-data['"]/
  end

  def bundle_install
    Bundler.with_clean_env do
      system! "bundle install"
    end
  end
end
