# frozen_string_literal: true

require_relative "../test/test_helper"

class BasicEncryptionTest < ActiveSupport::TestCase
  setup do
    Faker::Lorem.stubs(:word).returns("anonymized_word")
  end
  test "Encrypts columns" do
    user = EncryptedUser.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "anonymized_word", user.first_name
    assert_equal "anonymized_word", user.last_name
    assert_equal "anonymized_word", user.email

    assert_match "first_name: [FILTERED]", user.inspect
    assert_match "last_name: [FILTERED]", user.inspect
    assert_match "email: \"test@example.com\"", user.inspect
  end

  test "Encrypted column works with alias" do
    ActiveRecordAnonymizer.configuration.stubs(:alias_original_columns).returns(true)

    user = EncryptedUser.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "John", user.original_first_name
    assert_equal "Doe", user.original_last_name
    assert_equal "test@example.com", user.original_email
  end
end
