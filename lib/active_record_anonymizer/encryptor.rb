# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Encryptor
    attr_reader :attributes

    def initialize(model, attributes)
      @model = model
      @attributes = attributes
    end

    def encrypt
      if !rails_version_supported?
        raise ActiveRecordAnonymizer::UnsupportedVersionError,
              "ActiveRecordAnonymizer relies on Rails 7+ for encrypted columns."
      end

      @model.encrypts(*@attributes)
    end

    private

    def rails_version_supported?
      ActiveRecord::VERSION::MAJOR >= 7 && ActiveRecord::VERSION::MINOR >= 0
    end
  end
end
