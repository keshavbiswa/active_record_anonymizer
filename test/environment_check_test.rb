# frozen_string_literal: true

require_relative "../test/test_helper"

class EnvironmentCheckTest < ActiveSupport::TestCase
  setup do
    ActiveRecordAnonymizer.configuration.reset
    @user_class = Class.new(User)
  end

  teardown do
    ActiveRecordAnonymizer.configuration.environments = %i[test]
  end

  test "Does not return the anonymized value if anonymization is disabled" do
    user = @user_class.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "John", user.first_name
    assert_equal "test@example.com", user.email
    assert_equal "Doe", user.last_name

    user.update!(first_name: "Updated John", last_name: "Updated Doe", email: "updated@example.com")

    assert_equal "Updated John", user.first_name
    assert_equal "updated@example.com", user.email
    assert_equal "Updated Doe", user.last_name
  end
end
