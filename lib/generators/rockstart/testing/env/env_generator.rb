# frozen_string_literal: true

module Rockstart::Testing
  class EnvGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_dotenv_files
      template "dotenv.test.tt", ".env.test"
    end
  end
end
