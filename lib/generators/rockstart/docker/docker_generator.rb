# frozen_string_literal: true

class Rockstart::DockerGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "This generator configures a Rails Application to work with Docker"

  class_option :root_image, type: :string,
                            desc: "Docker image to build the container from",
                            default: "ruby:#{RUBY_VERSION}"

  class_option :app_home, type: :string,
                          desc: "Mount directory used within Docker image",
                          default: Rails.application.engine_name

  class_option :assets, type: :boolean,
                        desc: "Include frontend assets support (node|yarn)",
                        default: true

  class_option :postgres, type: :boolean,
                          desc: "Include Postgres support",
                          default: Rockstart::Env.postgres_db?

  def create_dockerignore
    copy_file "rockstart/dockerignore", ".dockerignore"
  end

  def create_dockerfile
    @root_image = options[:root_image]
    @app_home = options[:app_home]
    @postgres = options[:postgres]
    @assets = options[:assets]
    template "rockstart/app/Dockerfile-app", "Dockerfile"
  end

  def create_nginx_image
    @root_image = options[:root_image]
    @app_home = options[:app_home]
    template "rockstart/web/Dockerfile-web", "docker/web/Dockerfile"
    template "rockstart/web/nginx.conf", "docker/web/nginx.conf"
  end

  def add_docker_compose
    @app_home = options[:app_home]
    template "rockstart/docker-compose.yml", "docker-compose.yml"
    template "rockstart/docker-compose.test.yml", "docker-compose.test.yml"
  end
end
