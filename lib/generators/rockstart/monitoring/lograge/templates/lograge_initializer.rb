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
        payload[:user_id] = controller.current_user&.uid || :guest
      end
    end
  end
end

# rubocop:disable Layout/LineLength
# Report for rack_attack throttle responses in lograge
ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |name, start, finish, request_id, payload|
  logger = Lograge.logger.presence || Rails.logger
  formatted_message = LogrageUtil.format_rack_attack_throttle(name, start, finish, request_id, payload)
  logger.public_send(Lograge.log_level, formatted_message)
end
# rubocop:enable Layout/LineLength
