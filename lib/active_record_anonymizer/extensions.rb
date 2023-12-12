# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordAnonymizer
  module Extensions
    extend ActiveSupport::Concern

    class_methods do
      def anonymize(*attributes, with: nil, column_name: nil)
        check_for_invalid_arguments(attributes, with, column_name)
        check_for_missing_anonymized_columns(attributes)

        attributes.each do |attribute|
          define_anonymize_method(attribute, with, column_name)
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
      def define_anonymize_method(attribute, _with, column_name)
        anonymized_attr = column_name || "anonymized_#{attribute}"
        define_method(attribute) do
          self[anonymized_attr]
        end
      end
    end
  end
end
