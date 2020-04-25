# frozen_string_literal: true

# Support for tests that depend on Rails.cache
module CacheSupport
  def clear_rails_cache
    Rails.cache.clear
  end
end

RSpec.configure do |config|
  config.include CacheSupport

  config.around(type: :request) do |example|
    clear_rails_cache
    example.run
    clear_rails_cache
  end
end
