# frozen_string_literal: true

module ActiveRecordAnonymizer
  class AttributesAnonymizer
    attr_reader :model

    def initialize(model, skip_update: false)
      @model = model
      @skip_update = skip_update
    end

    def anonymize_columns
      if model.new_record?
        anonymize_all_attributes
      else
        # Skip updating the record if skip_update is true
        return if @skip_update

        anonymize_changed_columns
      end
    end

    def populate
      anonymize_all_attributes
      model.save!
    end

    private

    def anonymize_all_attributes
      model.class.anonymized_attributes.each_value do |settings|
        generate_and_write_fake_value(settings[:column], settings[:with])
      end
    end

    def anonymize_changed_columns
      changes = model.changes.keys.map(&:to_sym)
      changed_columns = changes & model.class.anonymized_attributes.keys

      changed_columns.each do |column|
        settings = model.class.anonymized_attributes[column]
        generate_and_write_fake_value(settings[:column], settings[:with])
      end
    end

    def generate_and_write_fake_value(anonymized_attr, with_strategy = nil)
      fake_value = case with_strategy
                   when Proc
                     with_strategy.call(model)
                   when Symbol
                     model.send(with_strategy)
                   else
                     FakeValue.new(anonymized_attr, model.class.columns_hash[anonymized_attr.to_s]).generate_fake_value
                   end
      model.write_attribute(anonymized_attr, fake_value)
    end
  end
end
