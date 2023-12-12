# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordAnonymizer
  module Extensions
    extend ActiveSupport::Concern

    included do
      class_attribute :anonymized_attributes
      self.anonymized_attributes = {}

      before_save :anonymize_columns
    end

    class_methods do # rubocop:disable Metrics/BlockLength
      def anonymize(*attributes, with: nil, column_name: nil)
        check_for_invalid_arguments(attributes, with, column_name)
        check_for_missing_anonymized_columns(attributes)

        attributes.each do |attribute|
          anonymized_attr = column_name || "anonymized_#{attribute}"
          anonymized_attributes[attribute.to_sym] = anonymized_attr.to_sym
          define_anonymize_method(attribute, with, anonymized_attr)
        end
      end

      private

      def check_for_missing_anonymized_columns(attributes)
        missing_columns = attributes.reject do |attribute|
          columns_hash["anonymized_#{attribute}"]
        end

        if missing_columns.any?
          raise ColumnNotFoundError, <<~ERROR_MESSAGE.strip
            Following columns do not have anonymized_columns: #{missing_columns.join(', ')}.
            You can generate them by running `rails g anonymize #{name} #{missing_columns.join(' ')}`
          ERROR_MESSAGE
        end
      end

      def check_for_invalid_arguments(attributes, with, column_name)
        if attributes.size > 1 && (with || column_name)
          raise InvalidArgumentsError, "with and column_names are not supported for multiple attributes. Try adding them seperately"
        end
      end

      # This defines a method that returns the anonymized value of the attribute.
      # It also creates an alias "original_#{attribute}" that returns the original value. (TODO)
      # If column_name is provided, it will be used instead of "anonymized_#{attribute}"
      def define_anonymize_method(attribute, _with, anonymized_attr)
        define_method(attribute) do
          self[anonymized_attr]
        end
      end
    end

    def anonymize_columns
      if new_record?
        # For new records, apply anonymization to all attributes
        anonymize_all_attributes
      else
        # For existing records, only apply to attributes that have changed
        anonymize_changed_attributes
      end
    end

    def anonymize_all_attributes
      anonymized_attributes.each_value do |anonymized_attr|
        write_attribute(anonymized_attr, "Anonymized")
      end
    end

    def anonymize_changed_attributes
      changes = self.changes.keys.map(&:to_sym)
      changed_attributes = changes & anonymized_attributes.keys

      changed_attributes.each do |attribute|
        anonymized_attr = anonymized_attributes[attribute]
        write_attribute(anonymized_attr, "Updated Anonymized")
      end
    end
  end
end
