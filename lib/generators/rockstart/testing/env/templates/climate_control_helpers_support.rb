# frozen_string_literal: true

require "climate_control"

# Helpers for managing ENV configuration within a Test Suite
module ClimateControlHelpers
  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end
end

RSpec.configure do |config|
  config.include ClimateControlHelpers
end
