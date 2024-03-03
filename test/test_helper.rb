# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment", __dir__)

require "rails/test_help"
require "mocha/minitest"
require "pry"

ActiveRecordAnonymizer.configure do |config|
  config.environments = %i[test]
  config.skip_update = false
  config.alias_original_columns = false
  config.alias_column_name = "original"
end
