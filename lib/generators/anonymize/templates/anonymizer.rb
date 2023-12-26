# frozen_string_literal: true

ActiveRecordAnonymizer.configure do |config|
  # Configure the environments in which anonymization is allowed.
  config.environments = %i[staging]

  # Uncomment the following line to skip updating anonymized_columns when updating the original columns.
  # config.skip_update = true
end
