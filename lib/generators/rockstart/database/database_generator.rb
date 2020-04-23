# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::DatabaseGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  postgres_class_option

  def generate_postgres
    return unless postgres?

    generate "rockstart:database:postgres"
  end
end
