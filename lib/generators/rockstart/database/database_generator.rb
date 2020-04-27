# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::DatabaseGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  postgres_class_option
  memcached_class_option

  def generate_postgres
    return unless postgres?

    generate "rockstart:database:postgres"
  end

  def generate_memcached
    return unless memcached?

    generate "rockstart:database:memcached"
  end

  def generate_storage
    generate "rockstart:database:storage"
  end
end
