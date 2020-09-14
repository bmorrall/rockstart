# frozen_string_literal: true

require "rockstart/base_generator"
require "rockstart/generators/migration_helpers"

module Rockstart::Authorization
  class DeviseGenerator < Rockstart::BaseGenerator
    include Rockstart::Generators::MigrationHelpers

    source_root File.expand_path("templates", __dir__)

    class_option :devise_layout, type: :string,
                                 desc: "Custom layout used by all devise controllers",
                                 default: "application"

    pundit_class_option

    def add_user_model
      directory "models", "app/models"
      migration_template "create_user_migration.rb.tt", "db/migrate/create_users.rb"
      migration_template "add_devise_to_users_migration.rb.tt", "db/migrate/add_devise_to_users.rb"
    end

    def install_devise
      Dir.mktmpdir do |dir|
        generate_devise_install(dir)
        directory File.join(dir, "config"), "config"
      end
    rescue LoadError
      abort("Please install devise gem!!!") if behavior == :invoke
    end

    def add_devise_controllers
      Dir.mktmpdir do |dir|
        generate_devise_controllers(dir)
        add_pundit_support(dir) if pundit?
        devise_controllers.each do |controller|
          copy_file File.join(dir, controller_path(controller)), controller_path(controller)
        end
      end
    rescue LoadError
      abort("Please install devise gem!!!") if behavior == :invoke
    end

    def generate_routes
      route <<~USER_ROUTE
        devise_for :users, controllers: {
          sessions: "users/sessions",
          passwords: "users/passwords",
          registrations: "users/registrations"
        }
      USER_ROUTE
    end

    def add_rspec_coverage
      directory "spec"
    end

    def update_application_url_concerns
      change_application_url("url_for_authentication", "new_user_session_path")
    end

    private

    def generate_devise_install(dir)
      initializer = build_devise_install_generator(dir)
      initializer.invoke_all

      update_initializer(dir)
      make_devise_paranoid(dir)
      send_email_on_email_change(dir)
      send_email_on_password_change(dir)
      add_translations(dir)
    end

    def build_devise_install_generator(dir)
      require "generators/devise/install_generator"

      initializer = ::Devise::Generators::InstallGenerator.new(
        report_stream: StringIO.new
      )
      initializer.destination_root = dir
      initializer
    end

    def update_initializer(dir)
      gsub_file devise_initializer(dir),
                /config\.mailer_sender = ['"][^'"]+['']/,
                'config.mailer_sender = ENV.fetch("DEVISE_MAILER_SENDER",' \
                " Rails.application.credentials.devise_mailer_sender)"
      gsub_file devise_initializer(dir),
                /config\.secret_key = ['"][^'"]+['']/,
                'config.secret_key = ENV.fetch("DEVISE_SECRET_KEY")'
      gsub_file devise_initializer(dir),
                /config\.pepper = ['"][^'"]+['']/,
                'config.pepper = ENV.fetch("DEVISE_PEPPER")'
    end

    def make_devise_paranoid(dir)
      gsub_file devise_initializer(dir),
                /config\.paranoid = (true|false)/,
                "config.paranoid = true"
      uncomment_lines devise_initializer(dir), /config\.paranoid = true/
    end

    def send_email_on_email_change(dir)
      gsub_file devise_initializer(dir),
                /config\.send_email_changed_notification = (true|false)/,
                "config.send_email_changed_notification = true"
      uncomment_lines devise_initializer(dir), /config\.send_email_changed_notification = true/
    end

    def send_email_on_password_change(dir)
      gsub_file devise_initializer(dir),
                /config\.send_password_change_notification = (true|false)/,
                "config.send_password_change_notification = true"
      uncomment_lines devise_initializer(dir), /config\.send_password_change_notification = true/
    end

    def add_translations(dir)
      inject_into_file File.join(dir, "config/locales/devise.en.yml"), after: /failure:$/ do
        "\n      deleted_account: " \
          "\"You've deleted your account. Please contact support if you want to recover it!\""
      end
    end

    def devise_initializer(dir)
      File.join(dir, "config", "initializers", "devise.rb")
    end

    def generate_devise_controllers(dir)
      require "generators/devise/controllers_generator"

      initializer = build_devise_controllers_generator(dir)
      initializer.scope = "users"
      initializer.invoke_all

      devise_controllers.each do |controller|
        add_layout_to_controller(dir, controller)
      end
    end

    def build_devise_controllers_generator(dir)
      initializer = ::Devise::Generators::ControllersGenerator.new(
        report_stream: StringIO.new
      )
      initializer.destination_root = dir
      initializer.source_paths.insert(1, File.join(self.class.source_root, "controllers"))
      initializer
    end

    def add_layout_to_controller(dir, controller)
      inject_into_file File.join(dir, controller_path(controller)), after: /< Devise::.*$/ do
        "\n  layout \"#{options[:devise_layout]}\"\n"
      end

      # Replace Generic resource routes with users
      gsub_file File.join(dir, controller_path(controller)), "/resource", "/users"
    end

    def add_pundit_support(dir)
      use_pundit_for_update_user_details(dir)
      add_pudit_authorize_current_user_method(dir)
      add_pudit_authorize_current_user_callback(dir)
      add_pudit_error_handling_concern(dir)
    end

    # rubocop:disable Layout/LineLength
    def use_pundit_for_update_user_details(dir)
      gsub_file File.join(dir, controller_path("registrations")),
                /\.permit\(:account_update.*\)/,
                ".permit(:account_update, keys: policy(current_user).permitted_attributes_for_update)"
    end
    # rubocop:enable Layout/LineLength

    def add_pudit_authorize_current_user_method(dir)
      inject_into_file File.join(dir, controller_path("registrations")), after: "protected\n" do
        "\n#{<<~'METHOD'.gsub(/([^\n]*)\n/, "  \\1\n")}"
          # Ensure the logged in user is able to update or destroy their account
          def authorize_current_user
            authorize current_user
          end
        METHOD
      end
    end

    def add_pudit_authorize_current_user_callback(dir)
      inject_into_file File.join(dir, controller_path("registrations")),
                       after: /before_action :configure_account_update_params.*$/ do
        "\n  before_action :authorize_current_user, only: %i[edit update destroy]"
      end
    end

    def add_pudit_error_handling_concern(dir)
      inject_into_file File.join(dir, controller_path("registrations")), after: /< Devise::.*$/ do
        "\n  include PunditErrorHandling\n"
      end
    end

    def controller_path(controller)
      File.join("app", "controllers", "users", "#{controller}_controller.rb")
    end

    def devise_controllers
      %w[sessions passwords registrations]
    end
  end
end
