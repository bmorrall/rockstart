# frozen_string_literal: true

class Rockstart::BasicUserGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  source_root File.expand_path("templates", __dir__)

  class_option :skip_migration, type: :boolean,
                                desc: "Skip migration generation",
                                default: false

  def add_namae_gem
    gem "namae"

    Bundler.clean_system("bundle install --quiet")
  end

  def add_basic_user_model
    directory "app"
    directory "spec"
  end

  def add_user_migration
    return if options[:skip_migration]

    migration_template "migration.rb.tt", "db/migrate/create_users.rb"
  end

  private

  def rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
  end
end
