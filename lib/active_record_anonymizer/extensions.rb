# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordAnonymizer
  module Extensions
    extend ActiveSupport::Concern

    class_methods do
      def anonymize(*attributes, with: nil, column_name: nil)
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

      def define_anonymize_method(attribute, with, column_name)
        # Will do some cool shit
      end
    end
  end
end
