# frozen_string_literal: true

module Rockstart::FrontendApp
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    def add_asset_rake_task
      copy_file "assets.rake", "lib/tasks/assets.rake"
    end
  end
end
