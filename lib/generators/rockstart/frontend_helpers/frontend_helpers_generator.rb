# frozen_string_literal: true

class Rockstart::FrontendHelpersGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_titles
    gem "title", github: "calebthompson/title"

    template "titles.en.yml.tt", "config/locales/titles.en.yml"

    gsub_file "app/views/layouts/application.html.erb", %r{\<title(.+)\</title},
              "<title><%= title %></title"
  end

  private

  def default_title
    Rails.application.class.to_s.split("::").first
  end
end
