# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "with a userinfo hash" do
    subject(:user) { described_class.new(userinfo) }

    let(:userinfo) do
      {
        "provider" => "auth0",
        "uid" => "auth0|1234",
        "info" => {
          "image" => "https://s.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=480",
          "name" => "John Smith",
          "nickname" => "jono65",
          "email" => nil
        }
      }
    end

    it { expect(user.id).to eq "auth0|1234" }
    it { expect(user.image).to eq "https://s.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=480" }

    describe "#name" do
      it { expect(user.name).to eq "John Smith" }

      it "falls back to nickname when name is an email (Auth0 Database Provider Default)" do
        userinfo.fetch("info")["name"] = "test@example.com"
        expect(user.name).to eq "jono65"
      end
    end

    describe "#first_name" do
      it { expect(user.first_name).to eq "John" }

      it "falls back to nickname when name is an email (Auth0 Database Provider Default)" do
        userinfo.fetch("info")["name"] = "test@example.com"
        expect(user.first_name).to eq "jono65"
      end
    end

    it { expect(user.to_s).to eq "John Smith" }

    it { is_expected.to be_persisted }
  end

  context "with no parameters" do
    subject(:user) { described_class.new }

    it { expect(user.id).to be_nil }
    it { expect(user.name).to be_nil }
    it { expect(user.first_name).to be_nil }
    it { expect(user.image).to be_nil }

    it { expect(user.to_s).to be_nil }

    it { is_expected.not_to be_persisted }
  end
end