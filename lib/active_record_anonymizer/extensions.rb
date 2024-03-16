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
            before_validation :anonymizer_anonymize_columns, if: :anonymizer_anonymization_enabled?
            @anonymizer_setup_done = true
          end
        end
      end
    end

    # Deliberately using anonymizer_ prefix to avoid conflicts
    def anonymizer_anonymization_enabled?
      ActiveRecordAnonymizer.anonymization_enabled?
    end

    # Deliberately using anonymizer_ prefix to avoid conflicts
    def anonymizer_anonymize_columns
      AttributesAnonymizer.new(self, skip_update: ActiveRecordAnonymizer.configuration.skip_update).anonymize_columns
    end
  end
end
