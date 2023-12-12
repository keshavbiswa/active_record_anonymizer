# frozen_string_literal: true

require "test_helper"

class TestBasicAnonymization < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "John", last_name: "Doe", email: "test@example.com")
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

  test "Updates the anonymized value with fake data upon creation" do
    @user.save!

    assert_equal "Anonymized", @user.first_name
    assert_equal "Anonymized", @user.last_name
    assert_equal "Anonymized", @user.email
  end

  test "Updates the anonymized value with fake data upon update" do
    @user.save!
    @user.update!(first_name: "Jane", email: "updated_test@example.com")

    assert_equal "Updated Anonymized", @user.first_name
    assert_equal "Updated Anonymized", @user.email
    assert_equal "Anonymized", @user.last_name
  end
end