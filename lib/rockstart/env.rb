# frozen_string_literal: true

module Rockstart
  # Helpers for analysing the current environment
  module Env
    # Default session name used in a Rails App
    def self.default_session_name
      "_#{Rails.application.class.module_parent.name.underscore}_session"
    end

    # rubocop:disable Style/DoubleNegation
    # Indicates Postgres is currently in use
    def self.postgres_db?
      !!(Rails.configuration.database_configuration[Rails.env]["adapter"] =~ /postgres/)
    end
    # rubocop:enable Style/DoubleNegation
  end
end
