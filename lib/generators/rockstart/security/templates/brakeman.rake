# frozen_string_literal: true

desc "Run brakeman check on your codebase"
task :brakeman do
  system "bundle exec brakeman -w 2 -o brakeman"
end
