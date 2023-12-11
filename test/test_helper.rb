# frozen_string_literal: true

require "rails"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment", __dir__)

require "minitest/autorun"
