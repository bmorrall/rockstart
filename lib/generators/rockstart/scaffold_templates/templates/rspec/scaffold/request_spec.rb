<%- resource_path = name.underscore.pluralize -%>
<%- permitted_params = attributes.map { |a| ":#{a.name}" }.join(", ") -%>
# frozen_string_literal: true

require "rails_helper"

<% module_namespacing do -%>
RSpec.describe "<%= controller_class_name %>", <%= type_metatag(:request) %> do
<% unless options[:singleton] -%>
  describe "GET /<%= resource_path %>" do
    context "with an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "renders a successful response" do
        create(:<%= file_name %>)
        get <%= index_helper %>_url
        expect(response).to be_successful
      end
    end

    context "with an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "renders a successful response" do
        create(:<%= file_name %>)
        get <%= index_helper %>_url
        expect(response).to be_successful
      end
    end

    context "with an unauthorized user" do
      let(:unauthorized_user) do
        skip("Provide a user where <%= class_name %>Policy.index? is not granted")
      end

      before do
        sign_in(unauthorized_user)
      end

      it "forbids access" do
        create(:<%= file_name %>)
        get <%= index_helper %>_url
        expect(response).to redirect_to(root_url)

        follow_redirect!
        expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.index?", default: t("pundit.default")))
      end
    end

    it "does not allow access to guests" do
      create(:<%= file_name %>)
      get <%= index_helper %>_url
      expect(response).to redirect_to(new_user_session_path)
    end
  end
<% end -%>

  describe "GET /<%= resource_path %>/:id" do
    context "with an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "renders a successful response" do
        <%= file_name %> = create(:<%= file_name %>)
        get <%= show_helper.tr('@', '') %>
        expect(response).to be_successful
      end
    end

    context "with an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "renders a successful response" do
        <%= file_name %> = create(:<%= file_name %>)
        get <%= show_helper.tr('@', '') %>
        expect(response).to be_successful
      end
    end

    context "with an unauthorized user" do
      let(:unauthorized_user) do
        skip("Provide a user where <%= class_name %>Policy.show? is not granted")
      end

      before do
        sign_in(unauthorized_user)
      end

      it "forbids access" do
        <%= file_name %> = create(:<%= file_name %>)
        get <%= show_helper.tr('@', '') %>
        expect(response).to redirect_to(<%= index_helper %>_url)

        follow_redirect!
        expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.show?", default: t("pundit.default")))
      end
    end

    it "does not allow access to guests" do
      <%= file_name %> = create(:<%= file_name %>)
      get <%= show_helper.tr('@', '') %>
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /<%= resource_path %>/new" do
    context "with an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "renders a successful response" do
        get <%= new_helper %>
        expect(response).to be_successful
      end
    end

    context "with an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "forbids access" do
        get <%= new_helper %>
        expect(response).to redirect_to(<%= index_helper %>_url)

        follow_redirect!
        expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.new?", default: t("pundit.default")))
      end
    end

    it "does not allow access to guests" do
      get <%= new_helper %>
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /<%= resource_path %>/:id/edit" do
    context "with an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "render a successful response" do
        <%= file_name %> = create(:<%= file_name %>)
        get <%= edit_helper.tr('@','') %>
        expect(response).to be_successful
      end
    end

    context "with an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "forbids access" do
        <%= file_name %> = create(:<%= file_name %>)
        get <%= edit_helper.tr('@','') %>
        expect(response).to redirect_to(<%= show_helper.tr('@', '') %>)

        follow_redirect!
        expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.edit?", default: t("pundit.default")))
      end
    end

    it "does not allow access to guests" do
      <%= file_name %> = create(:<%= file_name %>)
      get <%= edit_helper.tr('@','') %>
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST /<%= resource_path %>" do
    context "with valid parameters" do
      let(:valid_attributes) do
        <%- if attributes.any? -%>
        attributes_for(:<%= ns_file_name %>).slice(<%= permitted_params %>)
        <%- else -%>
        skip("Add a hash of attributes valid for your model")
        <%- end -%>
      end

      context "with an authenticated admin" do
        let(:authenticated_admin) { create(:user, :admin) }

        before do
          sign_in(authenticated_admin)
        end

        it "creates a new <%= class_name %>" do
          expect do
            post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
          end.to change(<%= class_name %>, :count).by(1)

          <%= file_name %> = <%= class_name %>.last
          <%- if attributes.any? -%>
          <%- attributes.each do |attribute| -%>
          expect(<%= file_name %>.<%= attribute.name %>).to eq(valid_attributes[:<%= attribute.name %>])
           <%- end -%>
          <%- else -%>
          skip("Add assertions for created state")
          <%- end -%>
        end

        it "redirects to the created <%= ns_file_name %>" do
          post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
          expect(response).to redirect_to(<%= show_helper.gsub("\@#{file_name}", class_name+".last") %>)
        end
      end

      context "with an authenticated user" do
        let(:authenticated_user) { create(:user) }

        before do
          sign_in(authenticated_user)
        end

        it "forbids access" do
          post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
          expect(response).to redirect_to(<%= index_helper %>_url)

          follow_redirect!
          expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.create?", default: t("pundit.default")))
        end
      end

      it "does not allow access to guests" do
        post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with invalid parameters" do
      let(:authenticated_admin) { create(:user, :admin) }

      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
      end

      before do
        sign_in(authenticated_admin)
      end

      it "does not create a new <%= class_name %>" do
        expect do
          post <%= index_helper %>_url, params: { <%= ns_file_name %>: invalid_attributes }
        end.to change(<%= class_name %>, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post <%= index_helper %>_url, params: { <%= ns_file_name %>: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /<%= resource_path %>/:id" do
    context "with valid parameters" do
      let(:new_attributes) do
        <%- if attributes.any? -%>
        attributes_for(:<%= ns_file_name %>).slice(<%= permitted_params %>)
        <%- else -%>
        skip("Add a hash of attributes valid for your model")
        <%- end -%>
      end

      context "with an authenticated admin" do
        let(:authenticated_admin) { create(:user, :admin) }

        before do
          sign_in(authenticated_admin)
        end

        it "updates the requested <%= ns_file_name %>" do
          <%= file_name %> = create(:<%= file_name %>)
          patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }

          <%= file_name %>.reload
          <%- if attributes.any? -%>
          <%- attributes.each do |attribute| -%>
          expect(<%= file_name %>.<%= attribute.name %>).to eq(new_attributes[:<%= attribute.name %>])
           <%- end -%>
          <%- else -%>
          skip("Add assertions for updated state")
          <%- end -%>
        end

        it "redirects to the <%= ns_file_name %>" do
          <%= file_name %> = create(:<%= file_name %>)
          patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }
          <%= file_name %>.reload
          expect(response).to redirect_to(<%= singular_table_name %>_url(<%= file_name %>))
        end
      end

      context "with an authenticated user" do
        let(:authenticated_user) { create(:user) }

        before do
          sign_in(authenticated_user)
        end

        it "forbids access" do
          <%= file_name %> = create(:<%= file_name %>)
          patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }
          expect(response).to redirect_to(<%= show_helper.tr('@', '') %>)

          follow_redirect!
          expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.update?", default: t("pundit.default")))
        end
      end

      it "does not allow access to guests" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with invalid parameters" do
      let(:authenticated_admin) { create(:user, :admin) }

      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
      end

      before do
        sign_in(authenticated_admin)
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /<%= resource_path %>/:id" do
    context "with an authenticated admin" do
      let(:authenticated_admin) { create(:user, :admin) }

      before do
        sign_in(authenticated_admin)
      end

      it "destroys the requested <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        expect do
          delete <%= show_helper.tr('@', '') %>
        end.to change(<%= class_name %>, :count).by(-1)
      end

      it "redirects to the <%= table_name %> list" do
        <%= file_name %> = create(:<%= file_name %>)
        delete <%= show_helper.tr('@', '') %>
        expect(response).to redirect_to(<%= index_helper %>_url)
      end
    end

    context "with an authenticated user" do
      let(:authenticated_user) { create(:user) }

      before do
        sign_in(authenticated_user)
      end

      it "forbids access" do
        <%= file_name %> = create(:<%= file_name %>)
        delete <%= show_helper.tr('@', '') %>
        expect(response).to redirect_to(<%= show_helper.tr('@', '') %>)

        follow_redirect!
        expect(response.body).to have_selector(".alert-error", text: t("pundit.example_policy.destroy?", default: t("pundit.default")))
      end
    end

    it "does not allow access to guests" do
      <%= file_name %> = create(:<%= file_name %>)
      delete <%= show_helper.tr('@', '') %>
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
<% end -%>
