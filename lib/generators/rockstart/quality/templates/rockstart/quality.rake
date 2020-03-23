# frozen_string_literal: true

require "rubocop/rake_task"

namespace :quality do
  RuboCop::RakeTask.new
end

desc "Run all code quality tools"
task quality: ["quality:rubocop"]
