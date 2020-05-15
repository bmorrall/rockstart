# frozen_string_literal: true

module Rockstart::Development
  class ReadmeGenerator < Rails::Generators::Base
    include Rails::Generators::AppName

    source_root File.expand_path("templates", __dir__)

    def copy_readme
      template "README.md"
    end
  end
end
