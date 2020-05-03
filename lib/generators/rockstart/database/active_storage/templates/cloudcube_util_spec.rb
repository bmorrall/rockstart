# frozen_string_literal: true

require "utils/cloudcube"

RSpec.describe Utils::Cloudcube do
  describe ".bucket" do
    it "handles US regions" do
      bucket = described_class.bucket "https://cloud-cube.s3.amazonaws.com/mycube"
      expect(bucket).to eq "cloud-cube"
    end

    it "handles EU regions" do
      bucket = described_class.bucket "https://cloud-cube-eu.s3.amazonaws.com/mycube"
      expect(bucket).to eq "cloud-cube-eu"
    end

    it "handles JP regions" do
      bucket = described_class.bucket "https://cloud-cube-jp.s3.amazonaws.com/mycube"
      expect(bucket).to eq "cloud-cube-jp"
    end

    it "handles nil" do
      bucket = described_class.bucket nil
      expect(bucket).to be_nil
    end
  end

  describe ".region" do
    it "handles US regions" do
      region = described_class.region "https://cloud-cube.s3.amazonaws.com/mycube"
      expect(region).to eq "us-east-1"
    end

    it "handles EU regions" do
      region = described_class.region "https://cloud-cube-eu.s3.amazonaws.com/mycube"
      expect(region).to eq "eu-west-1"
    end

    it "handles JP regions" do
      region = described_class.region "https://cloud-cube-jp.s3.amazonaws.com/mycube"
      expect(region).to eq "ap-northeast-1"
    end

    it "handles nil" do
      region = described_class.region nil
      expect(region).to be_nil
    end
  end

  describe ".public_prefix" do
    it "handles US regions" do
      public_prefix = described_class.public_prefix "https://cloud-cube.s3.amazonaws.com/mycube"
      expect(public_prefix).to eq "mycube/public"
    end

    it "handles nil" do
      public_prefix = described_class.public_prefix nil
      expect(public_prefix).to be_nil
    end
  end

  describe ".prefix" do
    it "handles US regions" do
      prefix = described_class.prefix "https://cloud-cube.s3.amazonaws.com/mycube"
      expect(prefix).to eq "mycube"
    end

    it "handles nil" do
      prefix = described_class.prefix nil
      expect(prefix).to be_nil
    end
  end
end
