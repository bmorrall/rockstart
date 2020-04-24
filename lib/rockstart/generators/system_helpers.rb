# frozen_string_literal: true

module Rockstart
  module Generators
    # Adds helpers for installing gems and interacting with the current system
    module SystemHelpers
      protected

      def system!(*args)
        system(*args) || abort("\n== Command #{args} failed ==")
      end
    end
  end
end
