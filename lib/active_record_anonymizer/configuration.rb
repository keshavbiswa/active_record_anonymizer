# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Configuration
    attr_accessor :environments, :skip_update

    def initialize
      @environments = %i[staging]
      @skip_update = false
    end
  end
end
