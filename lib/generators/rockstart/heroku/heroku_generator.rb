# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::HerokuGenerator < Rockstart::BaseGenerator
  include Rails::Generators::AppName

  source_root File.expand_path("templates", __dir__)

  postgres_class_option

  def create_procfile
    template "Procfile"
  end

  def create_app_json
    template "app.json"
  end
end
