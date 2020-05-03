# frozen_string_literal: true

require "active_support/core_ext/object/blank"

module Utils
  # Utilities for working with Cloudcube
  module Cloudcube
    REGION_LOOKUP = {
      "cloud-cube" =>	"us-east-1",
      "cloud-cube-eu"	=> "eu-west-1",
      "cloud-cube-jp" =>	"ap-northeast-1"
    }.freeze

    def self.region(cloudcube_url)
      REGION_LOOKUP.fetch bucket(cloudcube_url) if cloudcube_url.present?
    end

    def self.bucket(cloudcube_url)
      URI.parse(cloudcube_url).host.split(".").first if cloudcube_url.present?
    end

    def self.public_prefix(cloudcube_url)
      prefix(cloudcube_url) + "/public" if cloudcube_url.present?
    end

    def self.prefix(cloudcube_url)
      URI.parse(cloudcube_url).path[1..-1] if cloudcube_url.present?
    end
  end
end
