# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < ActiveSupport::TestCase
  setup do
    ActiveRecordAnonymizer.configuration.reset
  end

  test "default environments" do
    assert_equal %i[staging], ActiveRecordAnonymizer.configuration.environments
  end

  test "default skip_update" do
    assert_equal false, ActiveRecordAnonymizer.configuration.skip_update
  end

  test "custom environments" do
    ActiveRecordAnonymizer.configure do |config|
      config.environments = %i[staging test]
    end

    assert_equal %i[staging test], ActiveRecordAnonymizer.configuration.environments
  end

  test "custom skip_update" do
    ActiveRecordAnonymizer.configure do |config|
      config.skip_update = true
    end

    assert_equal true, ActiveRecordAnonymizer.configuration.skip_update
  end
end
