# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::TestingGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  source_root File.expand_path("templates", __dir__)

  devise_class_option
  auth0_class_option

  def add_dotenv
    generate "rockstart:testing:env", devise_option, auth0_option
  end

  def install_simplecov
    generate "rockstart:testing:simplecov"
  end

  def install_rspec
    generate "rockstart:testing:rspec"
  end
end
