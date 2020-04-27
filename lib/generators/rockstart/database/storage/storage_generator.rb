# frozen_string_literal: true

module Rockstart::Database
  class StorageGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def create_local_storage_directory
      create_file "storage/.keep", ""
    end

    def add_storage_configuration
      copy_file "storage.yml", "config/storage.yml"
    end
  end
end
