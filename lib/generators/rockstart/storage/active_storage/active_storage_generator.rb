# frozen_string_literal: true

require "rockstart/generators/template_helpers"

module Rockstart::Storage
  class ActiveStorageGenerator < Rails::Generators::Base
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    class_option :public_files, type: :boolean,
                                desc: "Upload files are publically available",
                                default: false

    def create_local_storage_directory
      create_file "storage/.keep", ""
    end

    def add_storage_configuration
      template "storage.yml", "config/storage.yml"
    end

    def add_better_s3_service
      copy_file "better_s3_service.rb", "lib/active_storage/service/better_s3_service.rb"
    end

    def add_cloudcube_util
      copy_file "cloudcube_util.rb", "lib/utils/cloudcube.rb"
      copy_file "cloudcube_util_spec.rb", "spec/utils/cloudcube_spec.rb"
    end

    def add_initializer
      copy_initializer "active_storage"
    end

    def add_active_storage_migrations
      rake "active_storage:install"
    end

    def update_cache_storage
      comment_lines "config/environments/production.rb", /config\.active_storage\.service = :local$/
      application(nil, env: :production) do
        <<~CONFIG
          config.active_storage.service = if ENV["CLOUDCUBE_ACCESS_KEY_ID"].present?
                                            :cloudcube
                                          else
                                            :local # fallback option
                                          end
        CONFIG
      end
    end

    private

    def public_files?
      options.fetch(:public_files)
    end
  end
end
