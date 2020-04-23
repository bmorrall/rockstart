# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Development
  class ScaffoldsGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    pundit_class_option

    def copy_scaffold_templates
      template "api_controller.rb.tt", "#{scaffold_controller_dir}/api_controller.rb.tt"
      template "controller.rb.tt", "#{scaffold_controller_dir}/controller.rb.tt"
    end

    def copy_rspec_scaffold_templates
      copy_file "rspec/scaffold/api_request_spec.rb.tt",
                "#{rspec_templates_dir}/scaffold/api_request_spec.rb"
      copy_file "rspec/scaffold/request_spec.rb.tt",
                "#{rspec_templates_dir}/scaffold/request_spec.rb"
    end

    private

    def scaffold_controller_dir
      @scaffold_controller_dir ||= "lib/templates/rails/scaffold_controller"
    end

    def rspec_templates_dir
      @rspec_templates_dir ||= "lib/templates/rspec"
    end
  end
end
