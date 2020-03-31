# frozen_string_literal: true

class Rockstart::PostgresGenerator < Rails::Generators::Base
  include Rails::Generators::AppName

  source_root File.expand_path("templates", __dir__)

  def copy_database_config
    template "rockstart/database_config.yml.tt", "config/database.yml"
  end
end
