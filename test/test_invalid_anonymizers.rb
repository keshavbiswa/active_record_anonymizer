# frozen_string_literal: true

require "test_helper"

class TestInvalidAnonymizers < ActiveSupport::TestCase
  test "raises ColumnNotFoundError if anonymized_columns are not generated" do
    error = assert_raises ActiveRecordAnonymizer::ColumnNotFoundError do
      UserWithoutAnonymizedColumn.create(first_name: "John", last_name: "Doe", email: "test@example.com")
    end

    expected_message = <<~ERROR_MESSAGE.strip
      Following columns do not have anonymized_columns: first_name, last_name, email.
      You can generate them by running `rails g anonymize UserWithoutAnonymizedColumn first_name last_name email`
    ERROR_MESSAGE

    assert_equal expected_message, error.message
  end

  test "raises InvalidArgumentsError error if with and column_names are provided for attributes more than one" do
    error = assert_raises ActiveRecordAnonymizer::InvalidArgumentsError do
      InvalidAnonymizedArgumentsUser.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    end

    assert_equal "with and column_names are not supported for multiple attributes. Try adding them seperately", error.message
  end
end
