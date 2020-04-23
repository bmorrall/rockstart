# frozen_string_literal: true

require "rockstart/generators/system_helpers"

module Rockstart::Security
  class BundlerAuditGenerator < Rails::Generators::Base
    include Rockstart::Generators::SystemHelpers

    source_root File.expand_path("templates", __dir__)

    def add_bundler_audit_gem
      gem "bundler-audit", github: "rubysec/bundler-audit", group: %i[development test]

      bundle_install
    end

    def add_rake_task
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
    end
  end
end
