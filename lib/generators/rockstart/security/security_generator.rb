# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::SecurityGenerator < Rockstart::BaseGenerator
  include Rails::Generators::AppName
  source_root File.expand_path("templates", __dir__)

  class_option :font_hosts, type: :array,
                            desc: "Known third-party hosts for Fonts",
                            default: []

  class_option :image_hosts, type: :array,
                             desc: "Known third-party hosts for Images",
                             default: []

  class_option :script_hosts, type: :array,
                              desc: "Known third-party hosts for (Java)Scripts",
                              default: []

  class_option :style_hosts, type: :array,
                             desc: "Known third-party hosts for Stylesheets",
                             default: []

  class_option :session_name, type: :string,
                              desc: "Name used for Rails Sessions",
                              default: Rockstart::Env.default_session_name

  def remove_tzinfo
    comment_lines "Gemfile", /gem ['"]tzinfo-data['"]/
  end

  def install_gems
    gem "bundler-audit", github: "rubysec/bundler-audit"
    gem "brakeman", group: %i[development test]
    gem "rack-attack"

    bundle_install
  end

  def configure_bundler_audit
    copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
  end

  def configure_brakeman
    copy_file "brakeman.rake", "lib/tasks/brakeman.rake"

    append_to_file ".gitignore", "brakeman\n"
  end

  def add_security_rake_tasks
    copy_file "security.rake", "lib/tasks/security.rake"
  end

  def configure_rack_attack
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

  def add_session_initializer
    template "session_store_initializer.rb.tt", "config/initializers/session_store.rb"
  end

  def add_content_security_policy
    template "content_security_policy_initializer.rb.tt",
             "config/initializers/content_security_policy.rb"

    copy_file "csp_violations_controller.rb", "app/controllers/csp_violations_controller.rb"
    route "resources :csp_violations, only: [:create]"

    template "content_security_spec.rb.tt", "spec/requests/content_security_spec.rb"
  end

  def enforce_ssl
    gsub_file "config/environments/production.rb",
              /config.force_ssl = .+$/,
              'config.force_ssl = ENV["ALLOW_INSECURE_HTTP"].to_i != 1'
    uncomment_lines "config/environments/production.rb", /config.force_ssl =/
  end

  private

  def font_hosts
    options[:font_hosts] || []
  end

  def image_hosts
    options[:image_hosts] || []
  end

  def script_hosts
    options[:script_hosts] || []
  end

  def style_hosts
    options[:style_hosts] || []
  end

  def session_name
    options[:session_name]
  end
end
