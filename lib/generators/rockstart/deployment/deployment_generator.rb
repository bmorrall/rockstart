# frozen_string_literal: true

class Rockstart::DeploymentGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def create_deployment_scripts
    add_script "setup-deployment"
    add_script "deployment"
  end

  private

  def add_script(script_name)
    template script_name, "bin/#{script_name}"
    File.chmod(0o755, Rails.root.join("bin", script_name))
  end
end
