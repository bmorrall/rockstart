require "rails_helper"

<% module_namespacing do -%>
RSpec.describe "/<%= name.underscore.pluralize %>", <%= type_metatag(:request) %> do
<% unless options[:singleton] -%>
  describe "GET /index" do
    it "renders a successful response" do
      create(:<%= file_name %>)
      get <%= index_helper %>_url
      expect(response).to be_successful
    end
  end
<% end -%>

  describe "GET /show" do
    it "renders a successful response" do
      <%= file_name %> = create(:<%= file_name %>)
      get <%= show_helper.tr('@', '') %>
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get <%= new_helper %>
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      <%= file_name %> = create(:<%= file_name %>)
      get <%= edit_helper.tr('@','') %>
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_attributes) do
        skip("Add a hash of attributes valid for your model")
      end

      it "creates a new <%= class_name %>" do
        expect do
          post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
        end.to change(<%= class_name %>, :count).by(1)
      end

      it "redirects to the created <%= ns_file_name %>" do
        post <%= index_helper %>_url, params: { <%= ns_file_name %>: valid_attributes }
        expect(response).to redirect_to(<%= show_helper.gsub("\@#{file_name}", class_name+".last") %>)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
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

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        skip("Add a hash of attributes valid for your model")
      end

      it "updates the requested <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }
        <%= file_name %>.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the <%= ns_file_name %>" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: new_attributes }
        <%= file_name %>.reload
        expect(response).to redirect_to(<%= singular_table_name %>_url(<%= file_name %>))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        skip("Add a hash of attributes invalid for your model")
      end

      it "renders a successful response (i.e. to display the 'edit' template)" do
        <%= file_name %> = create(:<%= file_name %>)
        patch <%= show_helper.tr('@', '') %>, params: { <%= singular_table_name %>: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
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
end
<% end -%>
