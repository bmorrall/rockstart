# frozen_string_literal: true

class Rockstart::PunditGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_pundit
    gem "pundit"
    gem "pundit-matchers", group: :test

    Bundler.clean_system("bundle install --quiet")
  end

  def add_pundit_exception_handling
    application <<~PUNDIT
      # Treat Pundit authentication failures as forbidden
      config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
    PUNDIT
  end

  def add_pundit_to_application_controller
    inject_into_file "app/controllers/application_controller.rb",
                     "  include Pundit\n",
                     before: /^end$/
  end

  def add_pundit_overrides_and_helpers
    directory "app"
    directory "config"
    directory "lib"
    directory "spec"
  end
end
