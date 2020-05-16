# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Monitoring
  class OkcomputerGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    memcached_class_option
    sidekiq_class_option

    def add_initalizer
      initializer_template "okcomputer"
    end

    def add_translations
      copy_file "okcomputer.en.yml", "config/locales/okcomputer.en.yml"
    end

    def add_request_spec
      copy_file "okcomputer_spec.rb", "spec/requests/okcomputer_spec.rb"
    end
  end
end
