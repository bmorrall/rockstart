# frozen_string_literal: true

class Rockstart::RspecGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def add_gems
    gem "factory_bot_rails", group: %i[development test]
    gem "faker", group: %i[development test]
    gem "rspec-rails", "~> 4.0.0", group: %i[development test]
    gem "shoulda-matchers", group: :test
  end

  def install_rspec_rails
    Bundler.with_clean_env do
      run "bundle install"
      generate "rspec:install"
    end
  end

  def configure_rspec
    append_file "spec/rails_helper.rb", <<~RSPEC

      RSpec.configure do |config|
        # Allow direct use of FactoryBot methods
        config.include FactoryBot::Syntax::Methods

        # Allow direct use of t() and l() in specs
        config.include AbstractController::Translation
      end
    RSPEC
  end

  def configure_shoulda_matchers
    append_file "spec/rails_helper.rb", <<~SHOULDA

      # Configure shoulda-matchers
      Shoulda::Matchers.configure do |config|
        config.integrate do |with|
          with.test_framework :rspec
          with.library :rails
        end
      end
    SHOULDA
  end

  def update_templates
    copy_file "rockstart/request_spec.erb", "lib/templates/rspec/scaffold/request_spec.rb"
    copy_file "rockstart/api_request_spec.erb", "lib/templates/rspec/scaffold/api_request_spec.rb"
    copy_file "rockstart/model_spec.erb", "lib/templates/rspec/model/model_spec.rb"
  end
end
