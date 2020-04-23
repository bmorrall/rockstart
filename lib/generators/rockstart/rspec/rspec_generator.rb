# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::RspecGenerator < Rockstart::BaseGenerator
  source_root File.expand_path("templates", __dir__)

  devise_class_option

  def add_gems
    gem "capybara", ">= 2.15", group: :test
    gem "dotenv-rails", groups: %i[development test]
    gem "factory_bot_rails", group: %i[development test]
    gem "faker", group: %i[development test]
    gem "rspec-rails", "~> 4.0.0", group: %i[development test]
    gem "shoulda-matchers", group: :test
    gem "simplecov", group: :test
  end

  def install_rspec_rails
    bundle_install do
      Dir.mktmpdir do |dir|
        generate_rspec_install(dir)
        template File.join(dir, ".rspec"), ".rspec"
        directory File.join(dir, "spec"), "spec"
      end
    end
  end

  def add_dotenv_files
    template "dotenv.test.tt", ".env.test"
  end

  def add_rspec_support
    directory "support", "spec/support"
  end

  def add_coverage_to_gitignore
    append_file ".gitignore", "coverage/\n"
  end

  private

  def generate_rspec_install(dir)
    require "generators/rspec/install/install_generator"

    initializer = ::Rspec::Generators::InstallGenerator.new(
      report_stream: StringIO.new
    )
    initializer.destination_root = dir
    initializer.invoke_all

    prepend_simplecov_start(dir)
    enable_support_directory(dir)
  end

  def prepend_simplecov_start(dir)
    prepend_file File.join(dir, "spec", "spec_helper.rb"), <<~SIMPLECOV
      # frozen_string_literal: true

      require "simplecov"
      SimpleCov.start("rails") do
        add_filter "/lib/templates"
      end

    SIMPLECOV
  end

  def enable_support_directory(dir)
    uncomment_lines File.join(dir, "spec", "rails_helper.rb"), /Dir.+spec.+support.+\.rb/
  end
end
