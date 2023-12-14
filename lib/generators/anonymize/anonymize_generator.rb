# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ActiveRecordAnonymizer
  class AnonymizeGenerator < ActiveRecord::Generators::Base
    include Rails::Generators::Migration

    class InvalidModelName < Thor::Error; end
    class InvalidArguments < Thor::Error; end

    source_root File.expand_path("templates", __dir__)

    argument :attributes, type: :array, default: [], banner: "attribute attribute"

    def generate_migration
      validate_model_name
      validate_arguments
      migration_template "migration.rb.erb", "db/migrate/anonymize_#{table_name}.rb"
    end

    private

    def validate_model_name
      raise InvalidModelName, "Invalid model name" unless model
    end

    def validate_arguments
      raise InvalidArguments, "Attributes are needed for the migration" if attributes.empty?

      attributes.each do |attribute|
        raise InvalidArguments, "#{attribute.name} is not a valid attribute for #{model}" unless model.columns_hash[attribute.name]
      end
    end

    def model
      class_name.safe_constantize
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with? "5"
    end
  end
end
