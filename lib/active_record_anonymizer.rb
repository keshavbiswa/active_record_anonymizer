# frozen_string_literal: true

require "active_record"
require "zeitwerk"
require "faker"

module ActiveRecordAnonymizer
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
      @models ||= []
      @models << model unless @models.include?(model)
    end

    def models
      @models || []
    end

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def eager_load!
      loader.eager_load
    end

    def anonymization_enabled?
      configuration.environments.include?(Rails.env.to_sym)
    end

    def load_model(klass_name)
      model = klass_name.safe_constantize
      raise Error, "Could not find class: #{klass_name}" unless model

      unless ActiveRecordAnonymizer.models.include?(model)
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
