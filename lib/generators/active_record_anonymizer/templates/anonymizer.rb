# frozen_string_literal: true

ActiveRecordAnonymizer.configure do |config|
  # Configure the environments in which anonymization is allowed.
  config.environments = %i[development]

  # Uncomment the following line to skip updating anonymized_columns when updating the original columns.
  # config.skip_update = true

  # Uncomment the following line to alias the original columns.
  # config.alias_original_columns = true

  # This will only work if config.alias_original_columns is set to true.
  # Change the alias column name. (original by default)
  # Model.original_column_name will provide the original value of the column.
  config.alias_column_name = "original"
end
