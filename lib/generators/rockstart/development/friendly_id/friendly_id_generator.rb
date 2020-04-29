# frozen_string_literal: true

require "rockstart/generators/template_helpers"

module Rockstart::Development
  class FriendlyIdGenerator < Rails::Generators::Base
    include Rockstart::Generators::TemplateHelpers

    source_root File.expand_path("templates", __dir__)

    def add_initializer
      copy_initializer "friendly_id"
    end
  end
end
