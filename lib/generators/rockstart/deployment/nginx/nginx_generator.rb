# frozen_string_literal: true

module Rockstart::Deployment
  class NginxGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    SENDFILE_REGEX = /#.+\.x_sendfile_header.+# for NGINX$/.freeze

    def configure_sendfiles
      inject_into_file "config/environments/production.rb", after: SENDFILE_REGEX do
        <<~'SENDFILE'.split("\n").map { |line| "  #{line}".rstrip }.join("\n")

          unless ENV['RAILS_SERVE_STATIC_FILES'].present?
            config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX
          end
        SENDFILE
      end
    end
  end
end
