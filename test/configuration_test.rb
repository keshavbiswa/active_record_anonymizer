# frozen_string_literal: true

require_relative "../test/test_helper"

class ConfigurationTest < ActiveSupport::TestCase
  # The reason why this returns test and not staging even though
  # the default value is set to staging is because the configuration
  # is overwritten in the test_helper.rb file.
  test "default environments" do
    assert_equal %i[test], ActiveRecordAnonymizer.configuration.environments
  end

  test "default skip_update" do
    assert_equal false, ActiveRecordAnonymizer.configuration.skip_update
  end

  test "default alias_original_columns" do
    assert_equal false, ActiveRecordAnonymizer.configuration.alias_original_columns
  end

  test "default alias_column_name" do
    assert_equal "original", ActiveRecordAnonymizer.configuration.alias_column_name
  end

  test "custom environments" do
    ActiveRecordAnonymizer.configuration.stubs(:environments).returns(%i[staging test])
    assert_equal %i[staging test], ActiveRecordAnonymizer.configuration.environments
  end

  test "alias_original_columns" do
    ActiveRecordAnonymizer.configuration.stubs(:alias_original_columns).returns(true)
    assert_equal true, ActiveRecordAnonymizer.configuration.alias_original_columns
  end

  test "alias_column_name" do
    ActiveRecordAnonymizer.configuration.stubs(:alias_column_name).returns("custom_original")
    assert_equal "custom_original", ActiveRecordAnonymizer.configuration.alias_column_name
  end
end
