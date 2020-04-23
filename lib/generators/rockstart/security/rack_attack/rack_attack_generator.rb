# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/system_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Security
  class RackAttackGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::SystemHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option

    def install_gem
      gem "rack-attack"

      bundle_install
    end

    def add_initializer
      initializer_template "rack_attack"
    end

    def add_rspec_support
      copy_file "cache_support.rb", "spec/support/cache.rb"
    end

    def enable_cache_store_for_all_environments
      application do
        <<~CACHE
          # Use memory_store cache for testing and default configurations
          config.cache_store = :memory_store
        CACHE
      end
      comment_lines "config/environments/test.rb", "config.cache_store = "
    end
  end
end
