# frozen_string_literal: true

require_relative "../../test/test_helper"

class ActiveRecordAnonymizer::InitiatorTest < ActiveSupport::TestCase
  setup do
    UserWithoutAnonymizeMethod.stubs(:anonymized_attributes).returns({})
  end

  test "#validate raises ColumnNotFoundError if anonymized_columns are not generated" do
    error = assert_raises ActiveRecordAnonymizer::ColumnNotFoundError do
      ActiveRecordAnonymizer::Initiator.new(UserWithoutAnonymizedColumn, %i[first_name last_name email]).validate
    end

    expected_message = <<~ERROR_MESSAGE.strip
      Following columns do not have anonymized_columns: first_name, last_name, email.
      You can generate them by running
      `rails g active_record_anonymizer:anonymize UserWithoutAnonymizedColumn first_name last_name email`
    ERROR_MESSAGE

    assert_equal expected_message, error.message
  end

  test "#validate raises InvalidArgumentsError error if with and column_names are provided for attributes more than one" do
    error = assert_raises ActiveRecordAnonymizer::InvalidArgumentsError do
      @anonymizer = ActiveRecordAnonymizer::Initiator.new(UserWithoutAnonymizeMethod, %i[first_name last_name email], with: "John Doe",
                                                                                                                       column_name: "John Doe")
      @anonymizer.validate
    end

    assert_equal "with and column_names are not supported for multiple attributes. Try adding them seperately", error.message
  end

  test "#configure_anonymization returns blank if attributes are empty" do
    ActiveRecordAnonymizer::Initiator.any_instance.stubs(:define_anonymize_method).with do
      user = UserWithoutAnonymizeMethod.new(email: "test@example.com", first_name: "John", last_name: "Doe")

      assert_changes -> { user.first_name }, from: "John", to: "" do
        anonymizer = ActiveRecordAnonymizer::Initiator.new(UserWithoutAnonymizeMethod, %i[email first_name last_name])
        anonymizer.configure_anonymization 
      end
    end
  end

  test "#configure_anonymization returns the anonymized value if there is a value" do
    ActiveRecordAnonymizer::Initiator.any_instance.stubs(:define_anonymize_method).with do
      user = UserWithoutAnonymizeMethod.new(email: "test@example.com", first_name: "John", last_name: "Doe")

      user.anonymized_first_name = "Anonymized First Name"
      user.anonymized_last_name = "Anonymized Last Name"
      user.anonymized_email = "anonymized@example.com"

      assert_equal "John", user.first_name
      assert_equal "Doe", user.last_name
      assert_equal "test@example.com", user.email

      anonymizer = ActiveRecordAnonymizer::Initiator.new(UserWithoutAnonymizeMethod, %i[email first_name last_name])
      anonymizer.configure_anonymization

      assert_equal "Anonymized First Name", user.first_name
      assert_equal "Anonymized Last Name", user.last_name
      assert_equal "anonymized@example.com", user.email
    end
  end
end
