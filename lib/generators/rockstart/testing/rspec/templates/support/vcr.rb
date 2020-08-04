# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  # Use rspec tags for vcr cassettes
  c.configure_rspec_metadata!

  c.cassette_library_dir = "spec/vcr"
  c.hook_into :webmock
end
