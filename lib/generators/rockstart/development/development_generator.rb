# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::DevelopmentGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  desc "Sets up your app for a Rocking time writing code"

  devise_class_option
  pundit_class_option

  def generate_dotfiles
    generate "rockstart:development:env", devise_option
  end

  def generate_scaffold_templates
    generate "rockstart:development:scaffolds", pundit_option
  end

  def generate_localhost_setup
    generate "rockstart:development:localhost_setup"
  end
end
