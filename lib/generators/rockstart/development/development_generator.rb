# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::DevelopmentGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  desc "Sets up your app for a Rocking time writing code"

  auth0_class_option
  devise_class_option
  postgres_class_option
  pundit_class_option

  def generate_dotfiles
    generate "rockstart:development:env", devise_option
  end

  def generate_scaffold_templates
    generate "rockstart:development:scaffolds", auth0_option, pundit_option
  end

  def generate_localhost_setup
    generate "rockstart:development:localhost_setup"
  end

  def setup_audited
    generate "rockstart:development:audited", auth0_option, postgres_option
  end

  def setup_friendly_id
    generate "rockstart:development:friendly_id"
  end
end
