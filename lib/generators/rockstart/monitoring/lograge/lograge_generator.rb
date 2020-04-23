# frozen_string_literal: true

require "rockstart/generators/template_helpers"

module Rockstart::Monitoring
  class LogrageGenerator < Rails::Generators::Base
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    def install_lograge
      gem "lograge"
      gem "logstash-event"

      copy_initializer "lograge"
    end
  end
end
