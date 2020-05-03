# frozen_string_literal: true

require "rockstart/generators/migration_helpers"

module Rockstart::Storage
  class PostgresGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::MigrationHelpers

    source_root File.expand_path("templates", __dir__)

    def copy_database_config
      template "config/database.yml.tt", "config/database.yml"
    end

    def enable_uuid_support
      migration_template "migration.rb.tt", "db/migrate/enable_uuid.rb"
    end
  end
end
