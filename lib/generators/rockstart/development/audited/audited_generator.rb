# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/migration_helpers"
require "rockstart/generators/template_helpers"

module Rockstart::Development
  class AuditedGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers
    include Rockstart::Generators::MigrationHelpers
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    auth0_class_option
    postgres_class_option

    def add_custom_audit_model
      template "audit.rb", "app/models/audit.rb"
      template "audit_spec.rb", "spec/models/audit_spec.rb"
    end

    def add_initializer
      copy_initializer "audited"
    end

    def add_migrations
      migration_template "install_audited.rb", "db/migrate/install_audited.rb"
      migration_template "add_audit_indexes.rb", "db/migrate/add_audit_indexes.rb"
    end

    def add_spec_support
      copy_spec_support "audited"
    end
  end
end
