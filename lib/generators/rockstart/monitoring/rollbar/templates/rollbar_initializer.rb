# frozen_string_literal: true

Rollbar.configure do |config|
  # Include limited current user information
  config.person_id_method = "uid"
  config.person_username_method = "nickname"
  config.person_email_method = nil

  # Enable Asynchronous Reporting
  config.use_thread

  # Send logger messages straight to Rollbar
  # require "rollbar/logger"
  # Rails.logger.extend(ActiveSupport::Logger.broadcast(Rollbar::Logger.new))
end
