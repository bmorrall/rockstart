# frozen_string_literal: true

module Rockstart
  module Generators
    # Adds helpers for common class options used by rockstart
    module ClassOptionHelpers
      extend ActiveSupport::Concern

      class_methods do
        def devise_class_option
          class_option :devise, type: :boolean,
                                desc: "Include Devise support",
                                default: true
        end

        def postgres_class_option
          class_option :postgres, type: :boolean,
                                  desc: "Include Postgres support",
                                  default: Rockstart::Env.postgres_db?
        end

        def pundit_class_option
          class_option :pundit, type: :boolean,
                                desc: "Include Pundit support",
                                default: true
        end
      end

      protected

      def devise?
        options.fetch(:devise)
      end

      def devise_option
        devise? ? "--devise" : "--no-devise"
      end

      def postgres?
        options.fetch(:postgres)
      end

      def postgres_option
        postgres? ? "--postgres" : "--no-postgres"
      end

      def pundit?
        options.fetch(:pundit)
      end

      def pundit_option
        pundit? ? "--pundit" : "--no-pundit"
      end
    end
  end
end
