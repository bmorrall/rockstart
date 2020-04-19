# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::DeviseGenerator < Rockstart::BaseGenerator
  include Rails::Generators::Migration

  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  source_root File.expand_path("templates", __dir__)

  class_option :devise_layout, type: :string,
                               desc: "Custom layout used by all devise controllers",
                               default: "application"

  class_option :pundit, type: :boolean,
                        desc: "Include Pundit support",
                        default: true

  class_option :skip_controllers, type: :boolean,
                                  desc: "Skip Generating custom Devise Controllers",
                                  default: false

  class_option :skip_migration, type: :boolean,
                                desc: "Skip create user model migration generation",
                                default: false

  class_option :skip_model, type: :boolean,
                            desc: "Skip model generation",
                            default: false

  def add_namae_gem
    gem "namae"
  end

  def add_user_model
    directory "models", "app/models"
  end

  def add_user_migration
    return if options[:skip_migration]

    migration_template "create_user_migration.rb.tt", "db/migrate/create_users.rb"
  end

  def install_devise
    gem "devise"

    bundle_install do
      Dir.mktmpdir do |dir|
        generate_devise_install(dir)
        directory File.join(dir, "config"), "config"
      end
    end
  end

  def add_devise_controllers
    return if options[:skip_controllers]

    Bundler.with_clean_env do
      Dir.mktmpdir do |dir|
        generate_devise_controllers(dir)
        add_pundit_support(dir) if options[:pundit]
        devise_controllers.each do |controller|
          copy_file File.join(dir, controller_path(controller)), controller_path(controller)
        end
      end
    end
  end

  def generate_user_model
    return if options[:skip_model]

    Bundler.with_clean_env do
      generate "devise", "User"
    end
  end

  def inject_routes
    return if options[:skip_controllers]

    controller_templates = devise_controllers.map do |controller|
      "    #{controller}: \"users/#{controller}\""
    end.join(",\n")

    gsub_file "config/routes.rb", /devise_for :users.*$$/ do
      ["devise_for :users, controllers: {", controller_templates, "  }"].join("\n")
    end
  end

  def add_rspec_coverage
    directory "spec"
  end

  def update_application_url_concerns
    change_application_url("url_for_authentication", "new_user_session_path")
  end

  def add_testing_variables
    append_file ".env.development", "DEVISE_MAILER_SENDER=devise-mailer@localhost\n"
    append_file ".env.test", "DEVISE_MAILER_SENDER=devise-mailer@example.com\n"
  end

  private

  def rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
  end

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

  def use_pundit_for_update_user_details(dir)
    gsub_file File.join(dir, controller_path("registrations")),
              /\.permit\(:account_update.*\)/,
              ".permit(:account_update, keys: policy(current_user).permitted_attributes_for_update)"
  end

  def add_pudit_authorize_current_user_method(dir)
    inject_into_file File.join(dir, controller_path("registrations")), after: "protected\n" do
      "\n" + <<~'METHOD'.gsub(/([^\n]*)\n/, "  \\1\n")
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
