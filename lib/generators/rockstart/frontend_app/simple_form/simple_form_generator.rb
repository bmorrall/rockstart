# frozen_string_literal: true

require "rockstart/generators/system_helpers"

module Rockstart::FrontendApp
  class SimpleFormGenerator < Rails::Generators::Base
    include Rockstart::Generators::SystemHelpers

    def install_simple_form
      gem "simple_form"

      bundle_install do
        generate "simple_form:install"
      end
    end
  end
end
