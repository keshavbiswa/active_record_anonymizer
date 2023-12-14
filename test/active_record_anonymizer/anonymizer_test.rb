# frozen_string_literal: true

require "test_helper"

class ActiveRecordAnonymizer::AnonymizerTest < ActiveSupport::TestCase
  # Two things are required for this tests to work accurately
  # It needs to be tested on a class without the anonymize method definition
  # This is to ensure there is no redefinition happening
  # It needs to be on a fresh class
  # We use an anonymous class for it
  setup do
    # This creates an anonymous subclass of UserWithoutAnonymizeMethod for each test
    @user_class = Class.new(UserWithoutAnonymizeMethod)
  end

  test "#validate raises ColumnNotFoundError if anonymized_columns are not generated" do
    error = assert_raises ActiveRecordAnonymizer::ColumnNotFoundError do
      ActiveRecordAnonymizer::Anonymizer.new(UserWithoutAnonymizedColumn, %i[first_name last_name email]).validate
    end

    expected_message = <<~ERROR_MESSAGE.strip
      Following columns do not have anonymized_columns: first_name, last_name, email.
      You can generate them by running `rails g anonymize UserWithoutAnonymizedColumn first_name last_name email`
    ERROR_MESSAGE

    assert_equal expected_message, error.message
  end

  test "#validate raises InvalidArgumentsError error if with and column_names are provided for attributes more than one" do
    error = assert_raises ActiveRecordAnonymizer::InvalidArgumentsError do
      @anonymizer = ActiveRecordAnonymizer::Anonymizer.new(@user_class, %i[first_name last_name email], with: "John Doe", column_name: "John Doe")
      @anonymizer.validate
    end

    assert_equal "with and column_names are not supported for multiple attributes. Try adding them seperately", error.message
  end

  test "#anonymize_attributes returns blank if attributes are empty" do
    user = @user_class.new(email: "test@example.com", first_name: "John", last_name: "Doe")
    assert_changes -> { user.first_name }, from: "John", to: "" do
      anonymizer = ActiveRecordAnonymizer::Anonymizer.new(@user_class, %i[email first_name last_name])
      anonymizer.anonymize_attributes
    end
  end

  test "#anonymize_attributes returns the anonymized value if there is a value" do
    user = @user_class.new(email: "test@example.com", first_name: "John", last_name: "Doe")

    user.anonymized_first_name = "Anonymized First Name"
    user.anonymized_last_name = "Anonymized Last Name"
    user.anonymized_email = "anonymized@example.com"

    assert_equal "John", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "test@example.com", user.email

    anonymizer = ActiveRecordAnonymizer::Anonymizer.new(@user_class, %i[email first_name last_name])
    anonymizer.anonymize_attributes

    assert_equal "Anonymized First Name", user.first_name
    assert_equal "Anonymized Last Name", user.last_name
    assert_equal "anonymized@example.com", user.email
  end
end
