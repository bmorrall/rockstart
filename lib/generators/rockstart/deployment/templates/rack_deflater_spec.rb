# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rack::Deflater", type: :request do
  describe "gzip compression" do
    let(:authenticated_user) { create(:user) }

    before do
      sign_in authenticated_user
    end

    it "supports gzip compression", :aggregate_failures do
      ["gzip", "deflate,gzip", "gzip,deflate"].each do |compression_method|
        get url_for_user_dashboard, headers: { "HTTP_ACCEPT_ENCODING" => compression_method }
        expect(response.headers["Content-Encoding"]).to eq "gzip"
        expect(read_gzip_body(response.body)).to be_present
      end
    end
  end

  def read_gzip_body(response_body)
    require "zlib"
    require "stringio"
    gz = Zlib::GzipReader.new(StringIO.new(response_body.to_s))
    gz.read
  end
end
