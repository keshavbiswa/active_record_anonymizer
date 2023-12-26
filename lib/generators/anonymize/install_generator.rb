# frozen_string_literal: true

require "rails/generators/base"

module ActiveRecordAnonymizer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Creates an anonymizer initializer file"
    def copy_initializer
      template "anonymizer.rb", "config/initializers/anonymizer.rb"
    end
  end
end
