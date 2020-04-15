# frozen_string_literal: true

SECURITY_TASKS = %w[
  bundle:audit
].freeze

desc "Run all security checks"
task security: SECURITY_TASKS
