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

    class_methods do
      def anonymize(*attributes, with: nil, column_name: nil)
        anonymizer = Anonymizer.new(self, attributes, with: with, column_name: column_name)
        anonymizer.validate

        anonymizer.anonymize_attributes
      end
    end

    private

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
