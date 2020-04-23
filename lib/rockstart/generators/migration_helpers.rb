# frozen_string_literal: true

module Rockstart
  module Generators
    # Adds helpers for generating migrations provided by rockstart
    module MigrationHelpers
      extend ActiveSupport::Concern

      included do
        include Rails::Generators::Migration

        # Implement the required interface for Rails::Generators::Migration.
        def self.next_migration_number(dirname)
          next_migration_number = current_migration_number(dirname) + 1
          ActiveRecord::Migration.next_migration_number(next_migration_number)
        end
      end

      protected

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
      end
    end
  end
end
