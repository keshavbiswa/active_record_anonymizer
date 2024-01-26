# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ActiveRecordAnonymizer
  class AnonymizeGenerator < ActiveRecord::Generators::Base
    include Rails::Generators::Migration

    class InvalidArguments < Thor::Error; end

    source_root File.expand_path("templates", __dir__)

    argument :attributes, type: :array, default: [], banner: "attribute attribute"

    def generate_migration
      validate_arguments
      migration_template "migration.rb.erb", "db/migrate/anonymize_#{table_name}.rb"
      output_instructions
    end

    private

    def output_instructions
      log "\n\n"
      log "Add the following to your model file:"
      log "\n"
      log anonymize_method_string
      log "\n"
    end

    def anonymize_method_string
      "  anonymize :#{attributes.map(&:name).join(', :')}\n"
    end

    def validate_arguments
      raise InvalidArguments, "Attributes are needed for the migration" if attributes.empty?
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with? "5"
    end
  end
end
