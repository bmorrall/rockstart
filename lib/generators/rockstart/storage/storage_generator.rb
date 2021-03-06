# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class Rockstart::StorageGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  postgres_class_option
  memcached_class_option

  def generate_postgres
    return unless postgres?

    generate "rockstart:storage:postgres"
  end

  def generate_memcached
    return unless memcached?

    generate "rockstart:storage:memcached"
  end

  def generate_active_storage
    generate "rockstart:storage:active_storage"
  end
end
