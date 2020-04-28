# frozen_string_literal: true

require "lograge_util"

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new

  # Update if using Rails in API mode
  # config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']

  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      params: event.payload[:params].except(*exceptions)
    }
  end

  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      remote_ip: controller.request.remote_ip,
      request_id: controller.request.request_id
    }.tap do |payload|
      if controller.respond_to?(:current_user)
        payload[:user_id] = controller.current_user&.id || :guest
      end
    end
  end
end

# rubocop:disable Layout/LineLength
# Report for rack-attack throttle responses in lograge
ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |name, start, finish, request_id, payload|
  logger = Lograge.logger.presence || Rails.logger
  logger.warn LogrageUtil.format_rack_attack_throttle(name, start, finish, request_id, payload)
end

# Report for rack-attack blocklist responses in lograge
ActiveSupport::Notifications.subscribe("blocklist.rack_attack") do |name, start, finish, request_id, payload|
  logger = Lograge.logger.presence || Rails.logger
  logger.warn LogrageUtil.format_rack_attack_blocklist(name, start, finish, request_id, payload)
end
# rubocop:enable Layout/LineLength
