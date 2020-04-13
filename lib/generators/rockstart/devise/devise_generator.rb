# frozen_string_literal: true

class Rockstart::DeviseGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  class_option :devise_layout, type: :string,
                               desc: "Custom layout used by all devise controllers",
                               default: "application"

  class_option :skip_controllers, type: :boolean,
                                  desc: "Skip Generating custom Devise Controllers",
                                  default: false

  class_option :skip_model, type: :boolean,
                            desc: "Skip model generation",
                            default: false

  def install_devise
    gem "devise"

    Bundler.clean_system("bundle install --quiet")

    Bundler.with_clean_env do
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
      end

      inject_into_file "config/routes.rb", after: /devise_for :users/ do
        template_partial = build_controllers_inject_string
        template_partial.gsub(/([^\n]*)\n/, "  \\1\n").gsub(/\A\s*/, "") # Prepend newlines
      end
    end
  end

  def build_controllers_inject_string
    controller_templates = devise_controllers.map do |controller|
      "  #{controller}: \"users/#{controller}\""
    end.join(",\n")
    [", controllers: {", controller_templates, "}"].join("\n")
  end

  def generate_user_model
    return if options[:skip_model]

    Bundler.with_clean_env do
      generate "devise", "User", "--primary-key-type=uuid"
    end
  end

  def add_rspec_coverage
    directory "spec"
  end

  def update_users_factory
    inject_into_file "spec/factories/users.rb", after: "factory :user do\n" do
      <<~'FACTORY'.gsub(/([^\n]*)\n/, "    \\1\n")
        email { Faker::Internet.email }
        password { Faker::Lorem.words(number: 3).join }
      FACTORY
    end
  end

  def add_testing_variables
    append_file ".env.development", "DEVISE_MAILER_SENDER=devise-mailer@localhost\n"
    append_file ".env.test", "DEVISE_MAILER_SENDER=devise-mailer@example.com\n"
  end

  private

  def generate_devise_install(dir)
    require "generators/devise/install_generator"

    initializer = ::Devise::Generators::InstallGenerator.new(
      report_stream: StringIO.new
    )
    initializer.destination_root = dir
    initializer.invoke_all

    update_initializer(dir)
    make_devise_paranoid(dir)
  end

  def update_initializer(dir)
    gsub_file temp_devise_initializer(dir),
              /config\.mailer_sender = ['"][^'"]+['']/,
              'config.mailer_sender = ENV.fetch("DEVISE_MAILER_SENDER",' \
              " Rails.application.credentials.devise_mailer_sender)"
    gsub_file temp_devise_initializer(dir),
              /config\.secret_key = ['"][^'"]+['']/,
              'config.secret_key = ENV.fetch("DEVISE_SECRET_KEY")'
    gsub_file temp_devise_initializer(dir),
              /config\.pepper = ['"][^'"]+['']/,
              'config.pepper = ENV.fetch("DEVISE_PEPPER")'
  end

  def make_devise_paranoid(dir)
    gsub_file temp_devise_initializer(dir),
              /config\.paranoid = (true|false)/,
              "config.paranoid = true"
    uncomment_lines temp_devise_initializer(dir), /config\.paranoid = true/
  end

  def temp_devise_initializer(dir)
    File.join(dir, "config", "initializers", "devise.rb")
  end

  def generate_devise_controllers(dir)
    require "generators/devise/controllers_generator"

    initializer = build_devise_controllers_generator(dir)
    initializer.scope = "users"
    initializer.invoke_all

    devise_controllers.each do |controller|
      add_layout_to_controller(dir, controller)
      copy_file File.join(dir, controller_path(controller)), controller_path(controller)
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

  def controller_path(controller)
    File.join("app", "controllers", "users", "#{controller}_controller.rb")
  end

  def devise_controllers
    %w[sessions passwords registrations]
  end
end
