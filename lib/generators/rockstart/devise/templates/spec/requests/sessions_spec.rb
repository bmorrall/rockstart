# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  it "signs user in and out" do
    user = create(:user, email: "user@example.org", password: "very-secret")

    sign_in user
    get root_path
    expect(controller.current_user).to eq(user)

    sign_out user
    get root_path
    expect(request).to redirect_to new_user_session_path
  end
end
