# frozen_string_literal: true

class Rockstart::DeviseGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  class_option :skip_model, type: :boolean,
                            desc: "Skip model generation",
                            default: false

  def install_devise
    gem "devise"

    Bundler.with_clean_env do
      run "bundle install"
      generate "devise:install"

      generate "devise", "User", "--primary-key-type=uuid" unless options[:skip_model]
    end
  end

  def add_rspec_coverage
    directory "spec"
  end
end
