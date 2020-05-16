# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::MonitoringGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  auth0_class_option
  devise_class_option
  memcached_class_option
  rollbar_class_option
  sidekiq_class_option

  def generate_lograge
    generate "rockstart:monitoring:lograge"
  end

  def generate_rollbar
    return unless rollbar?

    generate "rockstart:monitoring:rollbar",
             auth0_option,
             sidekiq_option
  end

  def generate_okcomputer
    generate "rockstart:monitoring:okcomputer", memcached_option, sidekiq_option
  end

  def generate_sidekiq_ui
    return unless sidekiq?

    generate "rockstart:monitoring:sidekiq_ui", devise_option
  end
end
