# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::MonitoringGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  memcached_class_option
  rollbar_class_option

  def generate_lograge
    generate "rockstart:monitoring:lograge"
  end

  def generate_rollbar
    return unless rollbar?

    generate "rockstart:monitoring:rollbar"
  end

  def generate_okcomputer
    generate "rockstart:monitoring:okcomputer", memcached_option
  end
end
