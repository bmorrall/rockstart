# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Monitoring
  class SidekiqUiGenerator < Rails::Generators::Base
    include Rockstart::Generators::ClassOptionHelpers

    source_root File.expand_path("templates", __dir__)

    devise_class_option

    def add_sidekiq_web_ui_for_devise
      return unless devise?

      route <<~DEVISE_UI
        require "sidekiq/web"
        authenticate :user, lambda { |u| u.admin? } do
          mount Sidekiq::Web => "/sidekiq"
        end
      DEVISE_UI
    end

    def add_sidekiq_web_ui_for_generic_authentication
      return if devise?

      route <<~GENERIC_UI
        require "sidekiq/web"
        require "admin_constraint"
        mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint
      GENERIC_UI
    end

    def add_sidekiq_specs
      copy_file "sidekiq_spec.rb", "spec/requests/sidekiq_spec.rb"
    end
  end
end
