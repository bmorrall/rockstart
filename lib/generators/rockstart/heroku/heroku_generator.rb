# frozen_string_literal: true

class Rockstart::HerokuGenerator < Rails::Generators::Base
  include Rails::Generators::AppName

  source_root File.expand_path("templates", __dir__)

  class_option :postgres, type: :boolean,
                          desc: "Include Postgres support",
                          default: Rockstart::Env.postgres_db?

  def create_procfile
    template "Procfile"
  end

  def create_app_json
    template "app.json"
  end

  private

  def postgres?
    options[:postgres]
  end
end
