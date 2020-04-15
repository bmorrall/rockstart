# frozen_string_literal: true

class Rockstart::SecurityGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_bundler_audit
    gem "bundler-audit", github: "rubysec/bundler-audit"

    Bundler.clean_system("bundle install --quiet")

    copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
  end

  def install_brakeman
    gem "brakeman", group: %i[development test]

    Bundler.clean_system("bundle install --quiet")

    copy_file "brakeman.rake", "lib/tasks/brakeman.rake"

    append_to_file ".gitignore", "brakeman\n"
  end

  def add_security_rake_tasks
    copy_file "security.rake", "lib/tasks/security.rake"
  end
end
