# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Rockstart
  module Generators
    # Adds helpers for common class options used by rockstart
    module ClassOptionHelpers
      extend ActiveSupport::Concern

      # rubocop:disable Metrics/BlockLength
      class_methods do
        def all_class_options
          auth0_class_option
          devise_class_option
          frontend_class_option
          memcached_class_option
          postgres_class_option
          pundit_class_option
          rollbar_class_option
          sidekiq_class_option
        end

        def auth0_class_option
          class_option :auth0, type: :boolean,
                               desc: "Include Auth0 support",
                               default: false
        end

        def devise_class_option
          class_option :devise, type: :boolean,
                                desc: "Include Devise support",
                                default: true
        end

        def frontend_class_option
          class_option :frontend, type: :boolean,
                                  desc: "Include frontend support",
                                  default: true
        end

        def memcached_class_option
          class_option :memcached, type: :boolean,
                                   desc: "Include Memcached support",
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

        def rollbar_class_option
          class_option :rollbar, type: :boolean,
                                 desc: "Include Rollbar support",
                                 default: true
        end

        def sidekiq_class_option
          class_option :sidekiq, type: :boolean,
                                 desc: "Include Sidekiq support",
                                 default: true
        end
      end
      # rubocop:enable Metrics/BlockLength

      protected

      def all_class_options
        [
          auth0_option,
          devise_option,
          frontend_option,
          memcached_option,
          postgres_option,
          pundit_option,
          rollbar_option,
          sidekiq_option
        ]
      end

      def auth0?
        options.fetch(:auth0)
      end

      def auth0_option
        auth0? ? "--auth0" : "--no-auth0"
      end

      def devise?
        options.fetch(:devise)
      end

      def devise_option
        devise? ? "--devise" : "--no-devise"
      end

      def frontend?
        options.fetch(:frontend)
      end

      def frontend_option
        frontend? ? "--frontend" : "--no-frontend"
      end

      def memcached?
        options.fetch(:memcached)
      end

      def memcached_option
        memcached? ? "--memcached" : "--no-memcached"
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

      def rollbar?
        options.fetch(:rollbar)
      end

      def rollbar_option
        rollbar? ? "--rollbar" : "--no-rollbar"
      end

      def sidekiq?
        options.fetch(:sidekiq)
      end

      def sidekiq_option
        sidekiq? ? "--sidekiq" : "--no-sidekiq"
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
