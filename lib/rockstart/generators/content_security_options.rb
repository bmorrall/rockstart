# frozen_string_literal: true

module Rockstart
  module Generators
    # Adds options for managing a content security policy
    module ContentSecurityOptions
      extend ActiveSupport::Concern

      included do
        class_option :font_hosts, type: :array,
                                  desc: "Known third-party hosts for Fonts",
                                  default: []

        class_option :image_hosts, type: :array,
                                   desc: "Known third-party hosts for Images",
                                   default: []

        class_option :script_hosts, type: :array,
                                    desc: "Known third-party hosts for (Java)Scripts",
                                    default: []

        class_option :style_hosts, type: :array,
                                   desc: "Known third-party hosts for Stylesheets",
                                   default: []
      end

      protected

      def content_security_options
        {
          "--font_hosts" => font_hosts,
          "--image_hosts" => image_hosts,
          "--script_hosts" => script_hosts,
          "--style_hosts" => style_hosts
        }.compact.map do |k, v|
          [k, v] if v.present?
        end.compact.flatten
      end

      def font_hosts
        options[:font_hosts] || []
      end

      def image_hosts
        options[:image_hosts] || []
      end

      def script_hosts
        options[:script_hosts] || []
      end

      def style_hosts
        options[:style_hosts] || []
      end
    end
  end
end
