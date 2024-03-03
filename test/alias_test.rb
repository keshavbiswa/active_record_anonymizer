# frozen_string_literal: true

require_relative "../test/test_helper"

class AliasTest < ActiveSupport::TestCase
  setup do
    # This is necessary to clear the cache of the loaded classes
    # ActiveAnonymizer::Extensions are loaded only once in User class
    # If we don't clear the cache, the configuration will not be reloaded
    ActiveSupport::Dependencies.clear

    ActiveRecordAnonymizer.configuration.stubs(:alias_original_columns).returns(true)
    Faker::Lorem.stubs(:word).returns("anonymized_word")
  end

  test "aliasing original columns" do
    user = User.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "anonymized_word", user.first_name
    assert_equal "anonymized_word", user.last_name
    assert_equal "anonymized_word", user.email

    assert_equal "John", user.original_first_name
    assert_equal "Doe", user.original_last_name
    assert_equal "test@example.com", user.original_email
  end

  test "aliasing original columns with custom column names" do
    ActiveRecordAnonymizer.configuration.stubs(:alias_column_name).returns("custom_original")
    user = User.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "John", user.custom_original_first_name
    assert_equal "Doe", user.custom_original_last_name
    assert_equal "test@example.com", user.custom_original_email
  end
end
