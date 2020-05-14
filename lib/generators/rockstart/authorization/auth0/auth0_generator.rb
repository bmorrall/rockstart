# frozen_string_literal: true

require "rockstart/base_generator"

module Rockstart::Authorization
  class Auth0Generator < Rockstart::BaseGenerator
    include Rails::Generators::AppName

    source_root File.expand_path("templates", __dir__)

    def add_utils
      template "auth0_util.rb", "lib/utils/auth0.rb"
      copy_file "auth0_util_spec.rb", "spec/utils/auth0_spec.rb"
    end

    def add_translations
      copy_file "auth0.en.yml", "config/locales/auth0.en.yml"
    end

    def add_initializer
      copy_file "auth0_initializer.rb", "config/initializers/auth0.rb"
    end

    def add_controllers
      directory "app"
      directory "spec"
    end

    def add_session_auth_to_controllers
      inject_into_file "app/controllers/application_controller.rb",
                       "  include SessionAuth\n",
                       before: /^end$/
    end

    def add_routes
      route <<~ROUTE
        # Auth0 Session Routes
        get "auth/sign_in" => "auth#new", as: :auth_sign_in
        get "auth/sign_out" => "auth#sign_out", as: :auth_sign_out
        delete "auth/sign_out" => "auth#destroy"

        get "callback" => "auth#callback"
        get "auth/failure" => "auth#failure"

      ROUTE
      change_application_url("url_for_authentication", "auth_sign_in_path")
    end

    def add_setup_rake_task
      template "auth0.rake.tt", "lib/tasks/auth0.rake"
    end
  end
end
