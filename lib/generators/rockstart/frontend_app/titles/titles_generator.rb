# frozen_string_literal: true

module Rockstart::FrontendApp
  class TitlesGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_titles_locale
      template "titles.en.yml.tt", "config/locales/titles.en.yml"
    end

    def update_application_template
      gsub_file "app/views/layouts/application.html.erb", %r{<title(.+)</title},
                "<title><%= title %></title"
    end

    private

    def default_title
      Rails.application.class.to_s.split("::").first
    end
  end
end
