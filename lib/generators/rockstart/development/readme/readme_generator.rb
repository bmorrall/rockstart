# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Development
  class ReadmeGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    auth0_class_option

    def copy_readme
      template "README.md"
    end
  end
end
