# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Password", type: :request do
  describe "GET /users/password/new" do
    context "as a guest" do
      it "renders a successful response" do
        get new_user_password_path
        expect(response).to be_successful
      end
    end
  end

  describe "POST /users/password" do
    context "with a known user email" do
      let(:valid_params) do
        {
          user: {
            email: create(:user).email
          }
        }
      end

      it "redirects the user to the login page" do
        post user_password_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)

        follow_redirect!
        expect(response.body).to have_selector(".alert-notice", text: t("devise.passwords.send_paranoid_instructions"))
      end

      it "sends a password reset email" do
        expect do
          post user_password_path, params: valid_params
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        delivery = ActionMailer::Base.deliveries.last
        expect(delivery.to).to eq [valid_params.dig(:user, :email)]
        expect(delivery.subject).to eq t("devise.mailer.reset_password_instructions.subject")

        # Verify the reset password token is present
        expected_url = edit_user_password_path(reset_password_token: "")
        expect(delivery.body.raw_source).to have_selector("a[href*=\"#{expected_url}\"]")
      end
    end

    context "with an unknown email address" do
      let(:unknown_user_params) do
        {
          user: {
            email: Faker::Internet.email
          }
        }
      end

      it "redirects the user to the login page" do
        post user_password_path, params: unknown_user_params
        expect(response).to redirect_to(new_user_session_path)

        follow_redirect!
        expect(response.body).to have_selector(".alert-notice", text: t("devise.passwords.send_paranoid_instructions"))
      end

      it "does not send any emails" do
        expect do
          post user_password_path, params: unknown_user_params
        end.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
  end

  describe "GET /users/password/edit" do
    context "with a valid password reset token" do
      let(:valid_reset_password_token) do
        create(:user).send(:set_reset_password_token)
      end

      it "redirects back to the password reset page without the reset_password_token param" do
        get edit_user_password_path, params: { reset_password_token: valid_reset_password_token }
        expect(response).to redirect_to(edit_user_password_path)

        follow_redirect!
        expect(response.body).to have_selector("form input[name='user[reset_password_token]'][value='#{valid_reset_password_token}']", visible: false)
      end
    end

    context "with an invalid password reset token" do
      let(:invalid_reset_password_token) do
        Faker::Lorem.words(number: 2).join
      end

      it "processes the invalid reset password token the same as a valid token" do
        get edit_user_password_path, params: { reset_password_token: invalid_reset_password_token }
        expect(response).to redirect_to(edit_user_password_path)

        follow_redirect!
        expect(response.body).to have_selector("form input[name='user[reset_password_token]'][value='#{invalid_reset_password_token}']", visible: false)
      end
    end

    context "with no password request token" do
      it "redirects the user with a warning" do
        get edit_user_password_path
        expect(response).to redirect_to(new_user_session_path)

        follow_redirect!
        expect(response.body).to have_selector(".alert-alert", text: t("devise.passwords.no_token"))
      end
    end
  end

  describe "PUT /users/password" do
    context "with valid password change params" do
      let(:user) { create(:user) }
      let(:valid_reset_password_token) do
        user.send(:set_reset_password_token)
      end
      let(:valid_password) do
        Faker::Lorem.words(number: 3).join
      end

      let(:valid_password_change_params) do
        {
          user: {
            reset_password_token: valid_reset_password_token,
            password: valid_password,
            password_confirmation: valid_password
          }
        }
      end

      it "redirects the user to the dashboard with a notice" do
        put user_password_path, params: valid_password_change_params
        expect(response).to redirect_to(root_url)

        follow_redirect!
        expect(response.body).to have_selector(".alert-notice", text: t("devise.passwords.updated"))
      end

      it "changes the users password" do
        put user_password_path, params: valid_password_change_params

        user.reload
        expect(user.valid_password?(valid_password)).to be(true)
      end
    end

    context "with non-matching passwords" do
      let(:user) { create(:user) }
      let(:valid_reset_password_token) do
        user.send(:set_reset_password_token)
      end
      let(:valid_password) do
        Faker::Lorem.words(number: 3).join
      end

      let(:valid_password_change_params) do
        {
          user: {
            reset_password_token: valid_reset_password_token,
            password: valid_password,
            password_confirmation: valid_password.reverse
          }
        }
      end

      it "responds with success (displays a form with errors)" do
        put user_password_path, params: valid_password_change_params

        expect(response).to be_successful
        expect(response.body).to have_selector(".field_with_errors")
      end
    end

    context "with an invalid password reset token" do
      let(:invalid_reset_password_token) do
        Faker::Lorem.words(number: 2).join
      end
      let(:valid_password) do
        Faker::Lorem.words(number: 3).join
      end

      let(:invalid_password_change_params) do
        {
          user: {
            reset_password_token: invalid_reset_password_token,
            password: valid_password,
            password_confirmation: valid_password.reverse
          }
        }
      end

      it "responds with success (displays a form with errors)" do
        put user_password_path, params: invalid_password_change_params

        expect(response).to be_successful
        expect(response.body).to have_content("Reset password token is invalid")
      end
    end
  end
end
