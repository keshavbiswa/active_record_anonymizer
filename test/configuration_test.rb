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

  test "custom environments" do
    ActiveRecordAnonymizer.configuration.stubs(:environments).returns(%i[staging test])
    assert_equal %i[staging test], ActiveRecordAnonymizer.configuration.environments
  end
end
