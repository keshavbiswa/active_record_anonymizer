# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordAnonymizer
  module Extensions
    extend ActiveSupport::Concern

    class_methods do
      def ensure_mutex_initialized
        unless defined?(@setup_mutex)
          @setup_mutex = Mutex.new
        end
      end

      def anonymize(*attributes, with: nil, column_name: nil, encrypted: false)
        ensure_mutex_initialized
        Encryptor.new(self, attributes).encrypt if encrypted

        ActiveRecordAnonymizer.register_model(self)

        # These class variables required to generate anonymized values
        # These are not thread safe!
        cattr_accessor :anonymized_attributes, instance_accessor: false unless respond_to?(:anonymized_attributes)
        self.anonymized_attributes ||= {}

        initiator = Initiator.new(self, attributes, with: with, column_name: column_name)
        initiator.validate
        initiator.configure_anonymization

        # I'm ensuring that the before_save callback is only added once
        # Models can call anonymize method multiple times per column
        @setup_mutex.synchronize do
          unless @anonymizer_setup_done
            before_validation :anonymize_columns, if: :anonymization_enabled?
            @anonymizer_setup_done = true
          end
        end
      end
    end

    def anonymization_enabled?
      ActiveRecordAnonymizer.anonymization_enabled?
    end

    def anonymize_columns
      AttributesAnonymizer.new(self, skip_update: ActiveRecordAnonymizer.configuration.skip_update).anonymize_columns
    end

    def anonymize_all_attributes
      self.class.anonymized_attributes.each_value do |settings|
        generate_and_write_fake_value(settings[:column], settings[:with])
      end
    end

    def anonymize_changed_attributes
      changes = self.changes.keys.map(&:to_sym)
      changed_attributes = changes & self.class.anonymized_attributes.keys

      changed_attributes.each do |attribute|
        settings = self.class.anonymized_attributes[attribute]
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
