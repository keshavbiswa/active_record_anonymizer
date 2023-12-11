# frozen_string_literal: true

require "active_record"
require "zeitwerk"

module ActiveRecordAnonymizer
  @loader = Zeitwerk::Loader.for_gem
  @loader.setup

  class Error < StandardError; end
  class ColumnNotFoundError < StandardError; end
  class InvalidArgumentsError < StandardError; end

  class << self
    attr_reader :loader

    def eager_load!
      loader.eager_load
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveRecordAnonymizer::Extensions
end

ActiveRecordAnonymizer.eager_load!
