# frozen_string_literal: true

# FriendlyId Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `friendly_id` class method or defining
# methods in your model.
#
# To learn more, check out the guide:
#
# http://norman.github.io/friendly_id/file.Guide.html

FriendlyId.defaults do |config|
  # ## Reserved Words
  #
  # Some words could conflict with Rails's routes when used as slugs, or are
  # undesirable to allow as slugs. Edit this list as needed for your app.
  config.use :reserved

  config.reserved_words = %w[
    new edit index session login logout users admin
    stylesheets assets javascripts images
    wp-admin wp-login password passwd
  ]

  config.treat_reserved_as_conflict = false

  ## Slugs

  # Use slugged for all friendly_ids
  config.use :slugged

  # Provide smaller (prettier) conflict resolution slug
  config.use(Module.new do
    def resolve_friendly_id_conflict(candidates)
      uuid = SecureRandom.uuid
      [
        apply_slug_limit(candidates.first, uuid),
        SecureRandom.hex(5)
      ].compact.join(friendly_id_config.sequence_separator)
    end
  end)

  # By default, FriendlyId's :slugged addon expects the slug column to be named
  # 'slug', but you can change it if you wish.
  config.slug_column = "slug"

  # By default, slug has no size limit, but you can change it if you wish.
  config.slug_limit = 100
end
