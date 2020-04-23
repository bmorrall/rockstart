# frozen_string_literal: true

class Rockstart::MailersGenerator < Rails::Generators::Base
  def add_smtp_mailer
    generate "rockstart:mailers:smtp_mailer"
  end
end
