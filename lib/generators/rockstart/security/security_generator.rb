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

  def install_rack_attack
    gem "rack-attack"

    Bundler.clean_system("bundle install --quiet")

    copy_file "rack_attack.rb", "config/initializers/rack_attack.rb"
    copy_file "cache_support.rb", "spec/support/cache.rb"

    application do
      <<~CACHE
        # Use memory_store cache for testing and default configurations
        config.cache_store = :memory_store
      CACHE
    end
    comment_lines "config/environments/test.rb", "config.cache_store = "
  end
end
