# frozen_string_literal: true

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  raise "Please install the rubocop-rails gem!!!" unless Rails.env.production?
end

namespace :rubocop do
  desc "Rebuild rubocop_todo.yml"
  task :auto_gen_config do
    require "rubocop"

    cli = RuboCop::CLI.new
    result = cli.run(["--auto-gen-config", "--exclude-limit", "100"])
    abort("RuboCop failed!") if result.nonzero?
  end
end
