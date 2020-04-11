# frozen_string_literal: true

class Rockstart::QualityGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "This generator configures code quality rules"

  class_option :rebuild_todo, type: :boolean,
                              desc: "Bundle installs rubocop and regenerates .rubocop_todo.yml",
                              default: true

  def add_rake_task
    copy_file "rockstart/quality.rake", "lib/tasks/quality.rake"
  end

  def install_rubocop
    copy_file "rockstart/rubocop.yml", ".rubocop.yml"

    gem "rubocop-rails", require: false

    return unless options[:rebuild_todo]

    # Rebuild .rubocop_todo.yml, ensuring only existing code is excluded
    run "bundle install --quiet && bundle exec rubocop --auto-gen-config --exclude-limit 100"
  end
end
