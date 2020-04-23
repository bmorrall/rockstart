# frozen_string_literal: true

require "rockstart/generators/template_helpers"

module Rockstart::Development
  class LocalhostSetupGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    def add_certificate_configuration
      template "localhost_domains.ext.tt", "#{app_name}_localhost.ext"
    end

    def add_setup_localhost_script
      script_template "setup-localhost"
    end

    def create_localhost_certificates
      append_file ".gitignore" do
        <<~GITIGNORE

          # localhost certificate authority
          localhostCA.*

          # Generated SSL Certificates
          certs/

        GITIGNORE
      end
    end
  end
end
