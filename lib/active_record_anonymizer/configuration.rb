# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Configuration
    attr_accessor :environments, :skip_update, :alias_original_columns, :alias_column_name

    def initialize
      @environments = %i[development]
      @skip_update = false
      @alias_original_columns = false
      @alias_column_name = "original"
    end

    # Reset all configuration options to defaults.
    # Required for tests to maintain isolation between test cases.
    def reset
      initialize
    end
  end
end
