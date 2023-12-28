# frozen_string_literal: true

require "test_helper"

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

  test "Updates the anonymized value with custom data upon update" do
    Faker::Name.stubs(:male_first_name).returns("Anonymous")
    Faker::Name.stubs(:male_last_name).returns("Person")
    @user.save!

    Faker::Name.stubs(:male_first_name).returns("UpdatedAnonymous")
    @user.update!(first_name: "Jane", email: "updated_test@example.com")

    assert_equal "UpdatedAnonymous", @user.first_name
    assert_equal "UpdatedAnonymous@example.com", @user.email
    assert_equal "Person", @user.last_name
  end
end
