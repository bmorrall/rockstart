# frozen_string_literal: true

# rubocop:disable Layout/LineLength
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

# Report for rack_attack throttle responses in lograge
ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |_name, start, finish, request_id, payload|
  req = payload[:request]

  filter_parameters = Rails.application.config.filter_parameters
  params = ActiveSupport::ParameterFilter.new(filter_parameters).filter(req.params)

  message_payload = {
    method: req.request_method,
    path: req.path,
    format: params[:format] || "html",
    controller: Rack::Attack.name,
    action: "throttle",
    status: 429,
    duration: (finish - start).to_f.round(2),
    params: params.except("controller", "action", "format", "id"),
    host: req.host,
    remote_ip: req.ip,
    request_id: request_id
  }
  formatted_message = Lograge.lograge_config.formatter.call(message_payload)
  logger = Lograge.logger.presence || Rails.logger
  logger.public_send(Lograge.log_level, formatted_message)
end
# rubocop:enable Layout/LineLength
