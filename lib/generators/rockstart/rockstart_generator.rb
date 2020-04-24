# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"

class RockstartGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers
  include Rockstart::Generators::ContentSecurityOptions

  desc "The quickest way for getting Rails Ready to Rock!"

  all_class_options

  def add_rebuid_script
    generate "rockstart:development:rebuild", *all_class_options, *content_security_options
  end

  def install_all_gems
    generate "rockstart:gemset", *all_class_options, *content_security_options
  end

  def run_rockstart_generators
    generate "rockstart:run", *all_class_options, *content_security_options
  end
end
