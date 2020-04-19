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

  describe "#given" do
    it "returns the given name from the name" do
      user = User.new(name: "John Smith")
      expect(user.given).to eq "John"
    end

    it "handles nil name valeus" do
      user = User.new(name: nil)
      expect(user.given).to be_nil
    end
  end

  describe "#family" do
    it "returns the family name from the name" do
      user = User.new(name: "John Smith")
      expect(user.family).to eq "Smith"
    end

    it "handles nil name valeus" do
      user = User.new(name: nil)
      expect(user.family).to be_nil
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

    it "falls back to a generic label when name is not present" do
      user = build_stubbed(:user, name: nil)
      allow(user).to receive(:id?).and_return(true)
      allow(user).to receive(:id).and_return(1234)
      expect(user.to_s).to eq "User #1234"
    end

    it "returns a generic label when user is not persisted" do
      user = User.new(name: nil)
      expect(user.to_s).to eq "Guest User"
    end
  end
end
