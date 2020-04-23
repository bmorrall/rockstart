# frozen_string_literal: true

module Rockstart
  module Generators
    # Adds helpers for generating template provided by rockstart
    module TemplateHelpers
      protected

      def script_template(script_name)
        template script_name, "bin/#{script_name}"
        File.chmod(0o755, Rails.root.join("bin", script_name))
      end
    end
  end
end
