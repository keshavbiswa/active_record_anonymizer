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

        attributes.each do |attribute|
          anonymized_attr = column_name || "anonymized_#{attribute}"
          anonymized_attributes[attribute.to_sym] = { column: anonymized_attr.to_sym, with: with }

          define_method(attribute) do
            read_attribute(anonymized_attr)
          end
        end
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
