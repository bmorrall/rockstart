# frozen_string_literal: true

class Rockstart::PostgresGenerator < Rails::Generators::Base
  include Rails::Generators::AppName
  include Rails::Generators::Migration

  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  source_root File.expand_path("templates", __dir__)

  def copy_database_config
    template "config/database.yml.tt", "config/database.yml"
  end

  def enable_uuid_support
    migration_template "migration.rb.tt", "db/migrate/enable_uuid.rb"
  end

  private

  def rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
  end
end
