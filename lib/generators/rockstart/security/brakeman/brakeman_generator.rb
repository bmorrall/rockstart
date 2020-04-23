# frozen_string_literal: true

require "rockstart/generators/system_helpers"

module Rockstart::Security
  class BrakemanGenerator < Rails::Generators::Base
    include Rockstart::Generators::SystemHelpers

    source_root File.expand_path("templates", __dir__)

    def install_brakeman_gem
      gem "brakeman", group: %i[development test]

      bundle_install
    end

    def add_rake_tasks
      copy_file "brakeman.rake", "lib/tasks/brakeman.rake"
    end

    def add_output_to_gitignore
      append_to_file ".gitignore", "brakeman\n"
    end
  end
end
