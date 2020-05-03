# frozen_string_literal: true

module Rockstart::Storage
  class MemcachedGenerator < Rails::Generators::Base
    # rubocop:disable Metrics/MethodLength
    def configure_production_env
      application(nil, env: :production) do
        <<~MEMCACHED
          # Use Memcached for Rails cache store
          memcache_servers = ENV.fetch("MEMCACHE_SERVERS") { ENV.fetch("MEMCACHIER_SERVERS", "") }
          config.cache_store = :mem_cache_store,
                               memcache_servers.split(","),
                               {
                                 username: ENV["MEMCACHIER_USERNAME"],
                                 password: ENV["MEMCACHIER_PASSWORD"],
                                 failover: true,
                                 socket_timeout: 1.5,
                                 socket_failure_delay: 0.2,
                                 down_retry_delay: 60,
                                 pool_size: ENV.fetch("RAILS_MAX_THREADS") { 5 }
                               }
        MEMCACHED
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
