# frozen_string_literal: true

class Rockstart::MonitoringGenerator < Rails::Generators::Base
  def generate_lograge
    generate "rockstart:monitoring:lograge"
  end
end
