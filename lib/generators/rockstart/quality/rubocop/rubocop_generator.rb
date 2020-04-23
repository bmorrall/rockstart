# frozen_string_literal: true

require "rockstart/base_generator"
module Rockstart::Quality
  class RubocopGenerator < Rockstart::BaseGenerator
    source_root File.expand_path("templates", __dir__)

    def add_default_configuration
      copy_file "rubocop.yml", ".rubocop.yml"
    end

    def add_rubocop_gem
      gem "rubocop-rails", require: false, group: %i[development test]
    end

    def add_rake_task
      copy_file "rubocop.rake", "lib/tasks/rubocop.rake"
    end

    # Rebuild .rubocop_todo.yml, ensuring only existing code is excluded
    def build_rubocop_todo
      bundle_install
      system! "bundle exec rake rubocop:auto_gen_config"
    end
  end
end
