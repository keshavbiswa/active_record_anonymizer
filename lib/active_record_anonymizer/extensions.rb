# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordAnonymizer
  module Extensions
    extend ActiveSupport::Concern

    included do
      ActiveRecordAnonymizer.register_model(self)
      class_attribute :anonymized_attributes
      self.anonymized_attributes = {}
      before_save :anonymize_columns, if: :anonymization_enabled?
    end

    class_methods do
      def anonymize(*attributes, with: nil, column_name: nil)
        anonymizer = Anonymizer.new(self, attributes, with: with, column_name: column_name)
        anonymizer.validate
        anonymizer.anonymize_attributes
      end
    end

    private

    def anonymization_enabled?
      ActiveRecordAnonymizer.anonymization_enabled?
    end

    def anonymize_columns
      if new_record?
        # For new records, apply anonymization to all attributes
        anonymize_all_attributes
      else
        # For existing records, only apply to attributes that have changed
        return if ActiveRecordAnonymizer.configuration.skip_update

        anonymize_changed_attributes
      end
    end

    def anonymize_all_attributes
      anonymized_attributes.each_value do |settings|
        generate_and_write_fake_value(settings[:column], settings[:with])
      end
    end

    def anonymize_changed_attributes
      changes = self.changes.keys.map(&:to_sym)
      changed_attributes = changes & anonymized_attributes.keys

      changed_attributes.each do |attribute|
        settings = anonymized_attributes[attribute]
        generate_and_write_fake_value(settings[:column], settings[:with])
      end
    end

    def generate_and_write_fake_value(anonymized_attr, with_strategy = nil)
      fake_value = case with_strategy
                   when Proc
                     with_strategy.call(self)
                   when Symbol
                     send(with_strategy)
                   else
                     FakeValue.new(anonymized_attr, self.class.columns_hash[anonymized_attr.to_s]).generate_fake_value
                   end
      write_attribute(anonymized_attr, fake_value)
    end
  end
end
