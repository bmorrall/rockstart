# frozen_string_literal: true

class Rockstart::TestingGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def add_dotenv
    generate "rockstart:testing:dotenv"
  end

  def install_simplecov
    generate "rockstart:testing:simplecov"
  end

  def install_rspec
    generate "rockstart:testing:rspec"
  end
end
