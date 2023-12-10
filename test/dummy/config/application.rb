# frozen_string_literal: true

require_relative "boot"

require "active_record"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.generators.system_tests = nil
  end
end
