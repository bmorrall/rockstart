# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::FrontendAppGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  class_option :force_url_helpers, type: :boolean,
                                   desc: "Force creation of blank Application URL Helpers",
                                   default: false

  def add_simple_form
    generate "rockstart:frontend_app:simple_form"
  end

  def install_titles
    generate "rockstart:frontend_app:titles"
  end

  def add_application_urls
    if !force_url_helpers? &&
       File.exist?(Rails.root.join("app", "controllers", "concerns", "application_urls.rb"))
      return # Don't override existing helpers
    end

    generate "rockstart:frontend_app:application_urls"
  end

  private

  def force_url_helpers?
    options.fetch(:force_url_helpers)
  end
end
