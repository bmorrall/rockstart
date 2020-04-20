# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::FrontendHelpersGenerator < Rockstart::BaseGenerator
  source_root File.expand_path("templates", __dir__)

  class_option :force_url_helpers, type: :boolean,
                                   desc: "Force creation of blank Application URL Helpers",
                                   default: false

  def install_simple_form
    gem "simple_form"

    bundle_install do
      generate "simple_form:install"
    end
  end

  def install_titles
    gem "title", github: "calebthompson/title"

    bundle_install

    template "titles.en.yml.tt", "config/locales/titles.en.yml"

    gsub_file "app/views/layouts/application.html.erb", %r{\<title(.+)\</title},
              "<title><%= title %></title"
  end

  def add_application_urls_concern
    if force_url_helpers? || !File.exist?(Rails.root.join(application_urls_concern_path))
      copy_file "application_urls.rb", application_urls_concern_path
    else
      say "Skipping #{application_urls_concern_path}"
    end
    inject_into_file "app/controllers/application_controller.rb",
                     "  include ApplicationUrls\n",
                     before: /^end$/
  end

  def add_application_urls_helper
    if force_url_helpers? || !File.exist?(Rails.root.join(application_urls_helper_path))
      copy_file "application_urls_helper.rb", application_urls_helper_path
    else
      say "Skipping #{application_urls_helper_path}"
    end
  end

  private

  def default_title
    Rails.application.class.to_s.split("::").first
  end

  def force_url_helpers?
    options.fetch(:force_url_helpers)
  end

  def application_urls_concern_path
    File.join("app", "controllers", "concerns", "application_urls.rb")
  end

  def application_urls_helper_path
    File.join("spec", "support", "application_urls_helper.rb")
  end
end
