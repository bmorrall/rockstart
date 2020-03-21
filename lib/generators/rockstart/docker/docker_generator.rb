class Rockstart::DockerGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

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
               default: (Rails.configuration.database_configuration[Rails.env]["adapter"] == "postgres")

  def create_dockerignore
    copy_file "rockstart/dockerignore", ".dockerignore"
  end

  def create_dockerfile
    @root_image = options[:root_image]
    @app_home = options[:app_home]
    @postgres = options[:postgres]
    @assets = options[:assets]
    template "rockstart/Dockerfile.erb", "Dockerfile"
  end
end
