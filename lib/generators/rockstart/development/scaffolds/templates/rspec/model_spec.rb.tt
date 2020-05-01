require "rails_helper"

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
<%-
# Generate scaffold with name or title, and a `slug:uniq` field to enable friendly_id
  friendly_id_attribute = attributes_names.detect { |name| %w(name title).include?(name) }
  using_friendly_id = friendly_id_attribute && attributes_names.any? { |name| %w(slug).include?(name) }
-%>
  <%- for attribute in attributes -%>
  # <%= attribute.name %>:<%= attribute.type %>
  it { is_expected.to have_db_column(:<%= attribute.name %>) }
  <%- if %w(email name title).include?(attribute.name) -%>
  it { is_expected.to validate_presence_of(:<%= attribute.name %>) }
  <%- end -%>
  <%- end -%>

  describe "audited" do
    it { should be_audited.only(%i[<%= attributes_names.join(" ") %>]) }
<% attributes.select(&:reference?).each do |attribute| -%>
    # it { should be_audited.associated_with(:<%= attribute.name %>) }
<% end -%>
  end
<% if using_friendly_id -%>

  describe "friendly_id" do
    it "generates a slug from <%= friendly_id_attribute %>" do
      <%= file_name %> = <%= class_name %>.new <%= friendly_id_attribute %>: "Example Slug"
      <%= file_name %>.send(:set_slug) # callback method used by friendly_id
      expect(<%= file_name %>.slug).to eq "example-slug"
    end
  end
  <%- end -%>
end
<% end -%>
