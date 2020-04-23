# frozen_string_literal: true

module Rockstart::Testing
  class SimplecovGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_simplecov_gem
      gem "simplecov", group: :test
    end

    def add_coverage_to_gitignore
      append_file ".gitignore", "coverage/\n"
    end
  end
end
