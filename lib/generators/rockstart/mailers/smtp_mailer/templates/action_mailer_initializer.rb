# frozen_string_literal: true

ActionMailer::Base.smtp_settings = {
  port: ENV["SMTP_PORT"],
  address: ENV["SMTP_SERVER"],
  user_name: ENV["SMTP_LOGIN"].presence,
  password: ENV["SMTP_PASSWORD"].presence,
  domain: ENV["APP_HOST"],
  authentication: :plain
}
