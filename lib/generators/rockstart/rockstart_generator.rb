# frozen_string_literal: true

class RockstartGenerator < Rails::Generators::Base
  desc "The quickest way for getting Rails Ready to Rock!"

  class_option :devise, type: :boolean,
                        desc: "Include Devise support",
                        default: true

  class_option :postgres, type: :boolean,
                          desc: "Include Postgres support",
                          default: Rockstart::Env.postgres_db?

  class_option :pundit, type: :boolean,
                        desc: "Include Pundit support",
                        default: true

  def generate_logging
    generate "rockstart:logging"
  end

  def generate_rspec
    generate "rockstart:rspec", devise_option
  end

  def generate_postgres
    return unless options[:postgres]

    generate "rockstart:postgres"
  end

  def generate_smtp_mailer
    generate "rockstart:smtp_mailer"
  end

  def generate_frontend_helpers
    generate "rockstart:frontend_helpers"
  end

  def generate_scaffold_templates
    generate "rockstart:scaffold_templates", pundit_option
  end

  def generate_devise
    return unless options[:devise]

    generate "rockstart:devise", pundit_option
  end

  def generate_pundit
    return unless options[:pundit]

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

  private

  def devise_option
    options[:devise] ? "--devise" : "--no-devise"
  end

  def postgres_option
    options[:postgres] ? "--postgres" : "--no-postgres"
  end

  def pundit_option
    options[:pundit] ? "--pundit" : "--no-pundit"
  end
end
