# frozen_string_literal: true

require "rockstart/generators/class_option_helpers"

module Rockstart::Deployment
  class DockerGenerator < Rails::Generators::Base
    include Rails::Generators::AppName
    include Rockstart::Generators::ClassOptionHelpers

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

    devise_class_option
    memcached_class_option
    postgres_class_option
    rollbar_class_option

    def create_dockerignore
      copy_file "dockerignore", ".dockerignore"
    end

    def create_dockerfile
      @root_image = options[:root_image]
      @app_home = options[:app_home]
      @assets = options[:assets]
      template "app/Dockerfile-app", "Dockerfile"
    end

    def create_nginx_image
      @root_image = options[:root_image]
      @app_home = options[:app_home]
      template "web/Dockerfile-web", "docker/web/Dockerfile"
      template "web/nginx.conf", "docker/web/nginx.conf"
    end

    def add_docker_compose
      @app_home = options[:app_home]
      template "docker-compose.yml", "docker-compose.yml"
      template "docker-compose.test.yml", "docker-compose.test.yml"
    end

    def create_certs_directory
      FileUtils.mkdir_p(Rails.root.join("docker", "certs", "web"))
      append_file ".gitignore", "\n# Docker Configuration\ndocker/certs\n"
    end

    def create_dotenv
      template "dotenv.docker.tt", ".env.docker"
    end

    private

    # Generates an example password
    def example_db_password
      require "base64"
      Base64.urlsafe_encode64(Rails.application.engine_name)
    end
  end
end
