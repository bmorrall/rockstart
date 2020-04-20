# frozen_string_literal: true

module Rockstart
  # Base class for defining rockstart generators
  class BaseGenerator < Rails::Generators::Base
    protected

    def bundle_install(&block)
      Bundler.clean_system("bundle install --quiet")
      Bundler.with_clean_env(&block) if block_given?
    end

    def gem(name, *args)
      gsub_file "Gemfile", /^  gem ['"]#{name}['"].+$/, ""
      super
    end

    def gsub_method(file, method_name, replacement_code = null)
      existing_method_regex = /  def #{method_name}...+?end$/m.freeze
      replacement_code = yield if block_given?
      replacement = replacement_code.split("\n").map { |line| "  #{line}".rstrip }.join("\n")
      gsub_file file, existing_method_regex, replacement
    end

    def change_application_url(name, target_url)
      method_definition = url_method_template(name, target_url)
      gsub_method "app/controllers/concerns/application_urls.rb", name, method_definition
      gsub_method "spec/support/application_urls_helper.rb", name, method_definition
    end

    private

    def url_method_template(method_name, target_url)
      ["def #{method_name}", "  #{target_url}", "end"].join("\n")
    end
  end
end
