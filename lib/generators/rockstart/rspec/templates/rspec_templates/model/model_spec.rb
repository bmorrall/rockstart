require "rails_helper"

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  <%- for attribute in attributes -%>
  # <%= attribute.name %>:<%= attribute.type %>
  it { is_expected.to have_db_column(:<%= attribute.name %>) }
  <%- if %w(email name title).include?(attribute.name) -%>
  it { is_expected.to validate_presence_of(:<%= attribute.name %>) }
  <%- end -%>
  <%- end -%>
end
<% end -%>
