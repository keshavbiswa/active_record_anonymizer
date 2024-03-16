# frozen_string_literal: true

require_relative "../test/test_helper"

class ValidationTest < ActiveSupport::TestCase
  setup do
    Faker::Lorem.stubs(:word).returns("anonymized_word")
  end

  test "Anonymizes columns with validations" do
    user = ValidatedUser.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal true, user.valid?

    assert_equal "anonymized_word", user.first_name
    assert_equal "anonymized_word", user.last_name
    assert_equal "anonymized_word", user.email
  end
end
