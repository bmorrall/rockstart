# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  # email:string
  it { is_expected.to have_db_column(:email) }
  # encrypted_password:string
  it { is_expected.to have_db_column(:encrypted_password) }
  # name:string
  it { is_expected.to have_db_column(:name) }
  it { is_expected.not_to validate_presence_of(:name) }
  # admin:boolean
  it { is_expected.to have_db_column(:admin).with_options(default: false) }
  # deleted_at:datetime
  it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }

  describe "#uid" do
    it "returns the id of the User" do
      user = build_stubbed(:user, name: nil)
      allow(user).to receive(:id).and_return("1234")
      expect(user.uid).to eq "1234"
    end
  end

  describe "#first_name" do
    it "returns the given name from the name" do
      user = User.new(name: "John Smith")
      expect(user.first_name).to eq "John"
    end

    it "handles nil name valeus" do
      user = User.new(name: nil)
      expect(user.first_name).to be_nil
    end
  end

  describe "#image" do
    it "returns a gravatar image based off the email address" do
      user = User.new(email: "test@example.com")
      expect(user.image).to eq "https://s.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=480"
    end
  end

  describe "#to_s" do
    it "returns the persisted name of the user" do
      user = User.new(name: "John Smith")
      user.changes_applied
      expect(user.to_s).to eq "John Smith"

      user.name = "Jack Smith"
      expect(user.to_s).to eq "John Smith"
    end

    it "falls back to a generic label" do
      user = build_stubbed(:user, name: nil)
      expect(user.to_s).to start_with "#<User:"
    end
  end
end
