# frozen_string_literal: true

require "active_record"
require "zeitwerk"
require "faker"

module ActiveRecordAnonymizer
  @mutex = Mutex.new

  @loader = Zeitwerk::Loader.for_gem
  @loader.ignore("#{__dir__}/generators")
  @loader.setup

  class Error < StandardError; end
  class ColumnNotFoundError < StandardError; end
  class InvalidArgumentsError < StandardError; end
  class UnknownColumnTypeError < StandardError; end

  class << self
    attr_reader :loader

    def register_model(model)
      @mutex.synchronize do
        @models ||= []
        @models << model unless @models.include?(model)
      end
    end

    def models
      @mutex.synchronize do
        @models ||= []
      end
    end

    def configure
      @mutex.synchronize do
        yield configuration if block_given?
      end
    end

    def configuration
      Thread.current[:active_record_anonymizer_configuration] ||= Configuration.new
    end

    def eager_load!
      loader.eager_load
    end

    def anonymization_enabled?
      @mutex.synchronize do
        configuration.environments.include?(Rails.env.to_sym)
      end
    end

    def load_model(klass_name)
      model = klass_name.safe_constantize
      raise Error, "Could not find class: #{klass_name}" unless model

      unless models.include?(model)
        raise Error, "#{klass_name} is not an anonymized model"
      end

      model
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveRecordAnonymizer::Extensions
end

ActiveRecordAnonymizer.eager_load!
