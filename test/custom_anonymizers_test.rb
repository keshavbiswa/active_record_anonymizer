# frozen_string_literal: true

require_relative "../test/test_helper"

class CustomAnonymizersTest < ActiveSupport::TestCase
  setup do
    @user = UserWithCustomAnonymize.new(first_name: "John", last_name: "Doe", email: "test@example.com")
  end

  test "anonymize returns blank if there is no value" do
    assert_equal "", @user.first_name
    assert_equal "", @user.last_name
    assert_equal "", @user.email
  end

  test "anonymize returns the anonymized value if there is a value" do
    @user.anonymized_first_name = "Anonymized First Name"
    @user.anonymized_last_name = "Anonymized Last Name"
    @user.anonymized_email = "anonymized@example.com"

    assert_equal "Anonymized First Name", @user.first_name
    assert_equal "Anonymized Last Name", @user.last_name
    assert_equal "anonymized@example.com", @user.email
  end

  test "Updates the anonymized value with custom data upon creation" do
    Faker::Name.stubs(:male_first_name).returns("Anonymous")
    Faker::Name.stubs(:male_last_name).returns("Person")
    @user.save!

    assert_equal "Anonymous", @user.first_name
    assert_equal "Person", @user.last_name
    assert_equal "Anonymous@example.com", @user.email
  end

  test "Updates the anonymized value with custom data upon update if skip_update is false" do
    Faker::Name.stubs(:male_first_name).returns("Anonymous")
    Faker::Name.stubs(:male_last_name).returns("Person")
    @user.save!

    Faker::Name.stubs(:male_first_name).returns("UpdatedAnonymous")
    @user.update!(first_name: "Jane", email: "updated_test@example.com")

    assert_equal "UpdatedAnonymous", @user.first_name
    assert_equal "UpdatedAnonymous@example.com", @user.email
    assert_equal "Person", @user.last_name
  end

  test "Doesn't update the anonymized value with custom data upon update if skip_update is true" do
    ActiveRecordAnonymizer.configuration.stubs(:skip_update).returns(true)

    Faker::Name.stubs(:male_first_name).returns("Anonymous")
    Faker::Name.stubs(:male_last_name).returns("Person")
    @user.save!

    Faker::Name.stubs(:male_first_name).returns("UpdatedAnonymous")
    @user.update!(first_name: "Jane", email: "updated_test@example.com")

    assert_equal "Anonymous", @user.first_name
    assert_equal "Anonymous@example.com", @user.email
    assert_equal "Person", @user.last_name
  end

  test "multiple anonymize calls doesn't add multiple before_validation callbacks" do
    assert_equal 1, UserWithCustomAnonymize._validation_callbacks.select { |c| c.kind == :before && c.filter == :anonymizer_anonymize_columns }.size
  end
end
