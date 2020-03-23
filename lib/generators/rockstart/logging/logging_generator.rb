# frozen_string_literal: true

class Rockstart::LoggingGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_lograge
    gem "lograge"
    gem "logstash-event"

    copy_file "rockstart/lograge_initializer.rb", "config/initializers/lograge.rb"
  end
end
