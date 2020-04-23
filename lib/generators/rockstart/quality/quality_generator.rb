# frozen_string_literal: true

require "rockstart/base_generator"

class Rockstart::QualityGenerator < Rockstart::BaseGenerator
  source_root File.expand_path("templates", __dir__)

  desc "This generator configures code quality rules"

  def add_quality_rake_task
    copy_file "quality.rake", "lib/tasks/quality.rake"
  end

  def generate_rubocop
    generate "rockstart:quality:rubocop"
  end
end
