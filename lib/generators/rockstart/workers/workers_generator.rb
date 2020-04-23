# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::WorkersGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  source_root File.expand_path("templates", __dir__)

  devise_class_option
  sidekiq_class_option

  def add_sidekiq
    return unless sidekiq?

    generate "rockstart:workers:sidekiq", devise_option
  end
end
