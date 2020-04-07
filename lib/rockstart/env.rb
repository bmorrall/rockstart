# frozen_string_literal: true

module Rockstart
  # Helpers for analysing the current environment
  module Env
    # Indicates Postgres is currently in use
    def self.postgres_db?
      (Rails.configuration.database_configuration[Rails.env]["adapter"] =~ /postgres/) && true
    end
  end
end
