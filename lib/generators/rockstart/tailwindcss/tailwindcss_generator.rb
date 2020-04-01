# frozen_string_literal: true

class Rockstart::TailwindcssGenerator < Rails::Generators::Base
  include Rails::Generators::AppName

  source_root File.expand_path("templates", __dir__)

  def install_tailwindcss
    run "yarn add tailwindcss"
    run "yarn tailwind init tailwind.config.js"
  end

  def install_purge_css
    run "yarn add @fullhuman/postcss-purgecss"
  end

  def update_postcss_config
    template "postcss.config.js"
  end

  def update_application_layout
    gsub_file "app/views/layouts/application.html.erb", /stylesheet_link_tag/, "stylesheet_pack_tag"
  end

  def add_stylesheet_to_application_js
    template "application.css", "app/javascript/#{app_name}/application.css"
    append_file "app/javascript/packs/application.js", "\nimport '../#{app_name}/application.css';\n"
  end
end
