# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ActiveRecordAnonymizer
  class AnonymizeGenerator < ActiveRecord::Generators::Base
    include Rails::Generators::Migration

    class InvalidModelName < Thor::Error; end
    class InvalidArguments < Thor::Error; end
    class InvalidModel < Thor::Error; end

    source_root File.expand_path("templates", __dir__)

    argument :attributes, type: :array, default: [], banner: "attribute attribute"

    def generate_migration
      validate_model_name
      validate_arguments
      migration_template "migration.rb.erb", "db/migrate/anonymize_#{table_name}.rb"
      add_anonymize_method_to_model
    end

    private

    def add_anonymize_method_to_model
      model_file_path = File.join("app", "models", "#{file_name}.rb")
      if File.exist?(model_file_path)
        inject_into_class(model_file_path, class_name, anonymize_method_string)
      end
    end

    def anonymize_method_string
      "  anonymize :#{attributes.map(&:name).join(', :')}\n"
    end

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
      klass = class_name.safe_constantize
      if klass.respond_to?(:connection) && klass.connection.table_exists?(klass.table_name)
        klass
      else
        raise InvalidModel, "#{class_name} is not a valid ActiveRecord model with a corresponding table"
      end
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with? "5"
    end
  end
end
