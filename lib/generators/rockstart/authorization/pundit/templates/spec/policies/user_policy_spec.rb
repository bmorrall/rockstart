# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, user_record) }

  let(:resolved_scope) { described_class::Scope.new(user, User.all).resolve }

  let(:user_record) do
    build_stubbed(:user).tap do |record|
      allow(record).to receive(:id).and_return(123)
    end
  end

  context "with a guest" do
    let(:user) { nil }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_actions(%i[new create]) }
    it { is_expected.to forbid_actions(%i[edit update]) }
    it { is_expected.to forbid_action(:destroy) }

    it "returns no items in scope" do
      expect(resolved_scope.to_sql).to eq(User.none.to_sql)
    end
  end

  context "with the same user" do
    let(:user) { user_record }

    it { is_expected.to permit_actions(%i[edit update]) }
    it { is_expected.to permit_action(:destroy) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_actions(%i[new create]) }

    it { is_expected.to permit_mass_assignment_of(:name).for_action(:update) }

    it "returns the a scope with only the user" do
      expect(resolved_scope.to_sql).to eq(User.where(id: user.id).to_sql)
    end

    context "when the user is an admin" do
      before do
        user.admin = true
      end

      it { is_expected.to permit_actions(%i[edit update]) }

      it { is_expected.to forbid_action(:index) }
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_actions(%i[new create]) }
      it { is_expected.to forbid_action(:destroy) }

      it { is_expected.to permit_mass_assignment_of(:name).for_action(:update) }

      it "returns the a scope with only the user" do
        expect(resolved_scope.to_sql).to eq(User.where(id: user.id).to_sql)
      end
    end
  end

  context "with a different user" do
    let(:user) do
      build_stubbed(:user).tap do |user|
        allow(user).to receive(:id).and_return(987)
      end
    end

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_actions(%i[new create]) }
    it { is_expected.to forbid_actions(%i[edit update]) }
    it { is_expected.to forbid_action(:destroy) }

    it { is_expected.to forbid_mass_assignment_of(:name).for_action(:update) }

    context "when the user is an admin" do
      before do
        user.admin = true
      end

      it { is_expected.to forbid_action(:index) }
      it { is_expected.to forbid_action(:show) }
      it { is_expected.to forbid_actions(%i[new create]) }
      it { is_expected.to forbid_actions(%i[edit update]) }
      it { is_expected.to forbid_action(:destroy) }

      it { is_expected.to forbid_mass_assignment_of(:name).for_action(:update) }
    end
  end
end
