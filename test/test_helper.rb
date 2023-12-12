# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment", __dir__)

require "rails/test_help"
require "mocha/minitest"
require "pry"
