<%-
  resource_path = name.underscore.pluralize
  permitted_attributes = attributes.reject { |a| a.name == "slug" }
  permitted_params = permitted_attributes.map { |a| ":#{a.name}" }.join(", ")
-%>
# frozen_string_literal: true

require "rails_helper"

<% module_namespacing do -%>
RSpec.describe "/<%= controller_class_name %>", <%= type_metatag(:request) %> do
  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # <%= controller_class_name %>Controller, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) do
    {}
  end

<% unless options[:singleton] -%>
  describe "GET /<%= resource_path %>" do
    it "renders a successful response" do
      create(:<%= file_name %>)
      get <%= index_helper %>_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end
<% end -%>

  describe "GET /<%= resource_path %>/:id" do
    it "renders a successful response" do
      <%= file_name %> = create(:<%= file_name %>)
      get <%= show_helper.tr('@', '') %>, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /<%= resource_path %>" do
    context "with valid parameters" do
      let(:valid_attributes) do
        <%- if permitted_attributes.any? -%>
        attributes_for(:<%= ns_file_name %>).slice(<%= permitted_params %>)
        <%- else -%>
        skip("Add a hash of attributes valid for your model")
        <%- end -%>
      end

      it "creates a new <%= class_name %>" do
        expect do
          post <%= index_helper %>_url,
               params: { <%= ns_file_name %>: valid_attributes }, headers: valid_headers, as: :json
        end.to change(<%= class_name %>, :count).by(1)
      end

      it "renders a JSON response with the new <%= ns_file_name %>" do
        post <%= index_helper %>_url,
             params: { <%= ns_file_name %>: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
      end

      it "does not create a new <%= class_name %>" do
        expect do
          post <%= index_helper %>_url,
               params: { <%= ns_file_name %>: invalid_attributes }, as: :json
        end.to change(<%= class_name %>, :count).by(0)
      end

      it "renders a JSON response with errors for the new <%= ns_file_name %>" do
        post <%= index_helper %>_url,
             params: { <%= ns_file_name %>: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "PATCH /<%= resource_path %>/:id" do
    context "with valid parameters" do
      let(:new_attributes) do
        <%- if permitted_attributes.any? -%>
        attributes_for(:<%= ns_file_name %>).slice(<%= permitted_params %>)
        <%- else -%>
        skip("Add a hash of attributes valid for your model")
        <%- end -%>
      end

      it "updates the requested <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>,
              params: { <%= singular_table_name %>: invalid_attributes }, headers: valid_headers, as: :json

        <%= file_name %>.reload
        <%- if permitted_attributes.any? -%>
        <%- permitted_attributes.each do |attribute| -%>
        expect(<%= file_name %>.<%= attribute.name %>).to eq(new_attributes[:<%= attribute.name %>])
        <%- end -%>
        <%- else -%>
        skip("Add assertions for updated state")
        <%- end -%>
      end

      it "renders a JSON response with the <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>,
              params: { <%= singular_table_name %>: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
      end

      it "renders a JSON response with errors for the <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>,
              params: { <%= singular_table_name %>: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /<%= resource_path %>/:id" do
    it "destroys the requested <%= ns_file_name %>" do
      <%= file_name %> = create(:<%= file_name %>)
      expect do
        delete <%= show_helper.tr('@', '') %>, headers: valid_headers, as: :json
      end.to change(<%= class_name %>, :count).by(-1)
    end
  end
end
<% end -%>
