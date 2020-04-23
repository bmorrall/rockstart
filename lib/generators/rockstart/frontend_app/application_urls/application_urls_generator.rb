# frozen_string_literal: true

module Rockstart::FrontendApp
  class ApplicationUrlsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_application_urls_concern
      copy_file "application_urls.rb", application_urls_concern_path
      inject_into_file "app/controllers/application_controller.rb",
                       "  include ApplicationUrls\n",
                       before: /^end$/
    end

    def add_application_urls_helper
      copy_file "application_urls_helper.rb", application_urls_helper_path
    end

    private

    def application_urls_concern_path
      File.join("app", "controllers", "concerns", "application_urls.rb")
    end

    def application_urls_helper_path
      File.join("spec", "support", "application_urls_helper.rb")
    end
  end
end
