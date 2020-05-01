# frozen_string_literal: true

Rails.application.config.after_initialize do
  Audited.audit_class = ::Audit
end
