# frozen_string_literal: true

module Rockstart::Development
  class GeneratorOverridesGenerator < Rails::Generators::Base
    include Rails::Generators::AppName

    source_root File.expand_path("templates", __dir__)

    def add_custom_resource_routes_generator
      template "resource_route_generator.rb",
               "lib/generators/rails/#{app_name}_resource_route_generator.rb"
    end

    # rubocop:disable Metrics/MethodLength
    def override_generator_defaults
      application do
        <<~DEFAULTS
          config.generators do |g|
            g.assets false
            g.helper false
            g.javascripts false
            g.scaffold_stylesheet false
            g.stylesheets false
            g.resource_route :#{app_name}_resource_route
          end
        DEFAULTS
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
