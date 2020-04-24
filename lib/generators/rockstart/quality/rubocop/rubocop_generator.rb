# frozen_string_literal: true

require "rockstart/generators/system_helpers"
module Rockstart::Quality
  class RubocopGenerator < Rails::Generators::Base
    include Rockstart::Generators::SystemHelpers

    source_root File.expand_path("templates", __dir__)

    def add_default_configuration
      copy_file "rubocop.yml", ".rubocop.yml"
    end

    def add_rake_task
      copy_file "rubocop.rake", "lib/tasks/rubocop.rake"
    end

    # Rebuild .rubocop_todo.yml, ensuring only existing code is excluded
    def build_rubocop_todo
      system! "bundle exec rake rubocop:auto_gen_config"
    end
  end
end
