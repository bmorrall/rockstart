# frozen_string_literal: true

class Rockstart::SmtpMailerGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def add_initializers
    directory "config/initializers"
  end
end
