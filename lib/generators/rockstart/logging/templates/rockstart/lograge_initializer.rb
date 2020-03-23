# frozen_string_literal: true

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
      request_id: controller.request.request_id,
      user_id: (controller.respond_to?(:current_user) && controller.current_user.try(:id)) || :guest
    }
  end
end
