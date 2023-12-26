# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Configuration
    attr_accessor :environments, :skip_update

    def initialize
      @environments = %i[staging]
      @skip_update = false
    end

    # Reset all configuration options to defaults.
    # Required for tests to maintain isolation between test cases.
    def reset
      initialize
    end
  end
end
