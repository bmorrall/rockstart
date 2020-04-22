# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::QualityGenerator < Rockstart::BaseGenerator
  source_root File.expand_path("templates", __dir__)

  desc "This generator configures code quality rules"

  class_option :rebuild_todo, type: :boolean,
                              desc: "Bundle installs rubocop and regenerates .rubocop_todo.yml",
                              default: true

  def add_quality_rake_task
    copy_file "quality.rake", "lib/tasks/quality.rake"
  end

  def install_rubocop
    copy_file "rubocop.yml", ".rubocop.yml"

    gem "rubocop-rails", require: false, group: %i[development test]

    copy_file "rubocop.rake", "lib/tasks/rubocop.rake"

    return unless options[:rebuild_todo]

    # Rebuild .rubocop_todo.yml, ensuring only existing code is excluded
    bundle_install do
      run "bundle exec rake rubocop:auto_gen_config"
    end
  end
end
