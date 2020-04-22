# frozen_string_literal: true

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
  raise "Please install the rubocop-rails gem!!!" unless Rails.env.production?
end
