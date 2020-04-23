# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

class RockstartGenerator < Rails::Generators::Base
  include Rockstart::Generators::ClassOptionHelpers

  desc "The quickest way for getting Rails Ready to Rock!"

  devise_class_option
  postgres_class_option
  pundit_class_option

  def generate_logging
    generate "rockstart:logging"
  end

  def setup_development_environment
    generate "rockstart:development", devise_option, pundit_option
  end

  def generate_rspec
    generate "rockstart:rspec", devise_option
  end

  def generate_postgres
    return unless postgres?

    generate "rockstart:postgres"
  end

  def generate_smtp_mailer
    generate "rockstart:smtp_mailer"
  end

  def generate_frontend_helpers
    generate "rockstart:frontend_helpers"
  end

  def generate_devise
    return unless devise?

    generate "rockstart:devise", pundit_option
  end

  def generate_pundit
    return unless pundit?

    generate "rockstart:pundit"
  end

  def generate_security
    generate "rockstart:security"
  end

  def generate_deployment
    generate "rockstart:deployment"
  end

  def generate_nginx
    generate "rockstart:nginx"
  end

  def generate_docker
    generate "rockstart:docker", postgres_option, devise_option
  end

  def generate_heroku
    generate "rockstart:heroku", postgres_option
  end

  def generate_quality
    generate "rockstart:quality"
  end
end
