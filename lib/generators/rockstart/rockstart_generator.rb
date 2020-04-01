# frozen_string_literal: true

class RockstartGenerator < Rails::Generators::Base
  desc "The quickest way for getting Rails Ready to Rock!"

  class_option :postgres, type: :boolean,
                          desc: "Include Postgres support",
                          default: Rockstart::Env.postgres_db?

  def generate_logging
    generate "rockstart:logging"
  end

  def generate_rspec
    generate "rockstart:rspec"
  end

  def generate_postgres
    return unless options[:postgres]

    generate "rockstart:postgres"
  end

  def generate_docker
    generate "rockstart:docker"
  end

  def generate_quality
    generate "rockstart:quality"
  end
end
