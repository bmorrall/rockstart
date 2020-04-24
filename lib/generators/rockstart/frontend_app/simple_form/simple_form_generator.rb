# frozen_string_literal: true

module Rockstart::FrontendApp
  class SimpleFormGenerator < Rails::Generators::Base
    def install_simple_form
      generate "simple_form:install"
    end
  end
end
