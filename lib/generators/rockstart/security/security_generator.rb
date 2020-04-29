# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"
require "rockstart/generators/content_security_options"
require "rockstart/generators/template_helpers"

class Rockstart::SecurityGenerator < Rails::Generators::Base
  include Rails::Generators::AppName
  include Rockstart::Generators::ClassOptionHelpers
  include Rockstart::Generators::ContentSecurityOptions
  include Rockstart::Generators::TemplateHelpers

  source_root File.expand_path("templates", __dir__)

  devise_class_option
  rollbar_class_option

  def add_bundler_audit
    generate "rockstart:security:bundler_audit"
  end

  def add_brakeman
    generate "rockstart:security:brakeman"
  end

  def add_rack_attack
    generate "rockstart:security:rack_attack", devise_option
  end

  def add_content_security_policy
    generate "rockstart:security:content_security", rollbar_option, *content_security_options
  end

  def add_security_rake_tasks
    copy_file "security.rake", "lib/tasks/security.rake"
  end

  def enforce_ssl
    gsub_file "config/environments/production.rb",
              /config.force_ssl = .+$/,
              'config.force_ssl = ENV["ALLOW_INSECURE_HTTP"].to_i != 1'
    uncomment_lines "config/environments/production.rb", /config.force_ssl =/
  end
end
