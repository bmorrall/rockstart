# frozen_string_literal: true

module Rockstart::Security
  class BrakemanGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_rake_tasks
      copy_file "brakeman.rake", "lib/tasks/brakeman.rake"
    end

    def add_output_to_gitignore
      append_to_file ".gitignore", "brakeman\n"
    end
  end
end
