# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Anonymizer
    attr_reader :model, :attributes, :with, :column_name

    def initialize(model, attributes, with: nil, column_name: nil)
      @model = model
      @attributes = attributes
      @with = with
      @column_name = column_name
    end

    # TODO: Extract this logic in a seperate Validation module/class
    def validate
      check_for_invalid_arguments(attributes, with, column_name)
      check_for_missing_anonymized_columns(attributes)
    end

    def anonymize_attributes
      attributes.each do |attribute|
        anonymized_column = anonymized_column_name(attribute)

        # I don't like that we're manipulating the class attribute here
        # This breaks the SRP for this method
        # TODO:- Will need to revisit how we set the class attribute later
        model.anonymized_attributes[attribute.to_sym] = { column: anonymized_column.to_sym, with: with }

        define_anonymize_method(attribute, anonymized_column)
      end
    end

    private

    def check_for_missing_anonymized_columns(attributes)
      missing_columns = attributes.reject do |attribute|
        model.columns_hash[anonymized_column_name(attribute)]
      end

      if missing_columns.any?
        raise ColumnNotFoundError, <<~ERROR_MESSAGE.strip
          Following columns do not have anonymized_columns: #{missing_columns.join(', ')}.
          You can generate them by running `rails g anonymize #{model.name} #{missing_columns.join(' ')}`
        ERROR_MESSAGE
      end
    end

    def check_for_invalid_arguments(attributes, with, column_name)
      if attributes.size > 1 && (with || column_name)
        raise InvalidArgumentsError, "with and column_names are not supported for multiple attributes. Try adding them seperately"
      end
    end

    def anonymized_column_name(attribute)
      column_name || generated_column_name(attribute)
    end

    def generated_column_name(attribute)
      "anonymized_#{attribute}"
    end

    # This defines a method that returns the anonymized value of the attribute.
    # It also creates an alias "original_#{attribute}" that returns the original value. (TODO)
    # If column_name is provided, it will be used instead of "anonymized_#{attribute}"
    def define_anonymize_method(attribute, anonymized_attr)
      model.define_method(attribute) do
        self[anonymized_attr]
      end
    end
  end
end
