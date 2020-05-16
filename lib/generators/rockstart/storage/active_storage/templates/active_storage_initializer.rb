# frozen_string_literal: true

require "utils/cloudcube"

Rails.application.configure do
  # Set active_storage background queues to low priority
  config.active_storage.queues.analysis = :low
  config.active_storage.queues.purge = :low
end
