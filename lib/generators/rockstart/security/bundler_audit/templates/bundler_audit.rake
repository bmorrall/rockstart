# frozen_string_literal: true

namespace :bundle do
  task :audit do
    require "bundler/audit/cli"

    IGNORE_LIST = [
      "CVE-2015-9284" # Using POST for OAuth
    ].freeze

    Bundler::Audit::CLI.start ["update"]
    Bundler::Audit::CLI.start ["check", "--ignore", IGNORE_LIST.join(",")]
  end
end
