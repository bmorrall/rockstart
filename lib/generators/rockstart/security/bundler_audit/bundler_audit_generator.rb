# frozen_string_literal: true

module Rockstart::Security
  class BundlerAuditGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_rake_task
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
    end
  end
end
