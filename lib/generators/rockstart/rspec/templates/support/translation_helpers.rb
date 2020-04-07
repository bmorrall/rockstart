# frozen_string_literal: true

RSpec.configure do |config|
  # Allow direct use of t() and l() in specs
  config.include AbstractController::Translation
end
