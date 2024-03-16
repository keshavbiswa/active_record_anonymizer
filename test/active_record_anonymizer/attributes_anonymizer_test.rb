# frozen_string_literal: true

require_relative "../test_helper"

class ActiveRecordAnonymizer::AttributesAnonymizerTest < ActiveSupport::TestCase
  setup do
    Faker::Lorem.stubs(:word).returns("random_word")
    @user = User.new(first_name: "John", last_name: "Doe", email: "test@example.com")
  end

  test "#anonymize_columns should anonymize all attributes if new_record?" do
    ActiveRecordAnonymizer::AttributesAnonymizer.new(@user).anonymize_columns

    assert_equal "random_word", @user.first_name
    assert_equal "random_word", @user.last_name
    assert_equal "random_word", @user.email
  end

  test "#anonymize_columns should anonymize only changed attributes if not new_record?" do
    @user.save!

    @user.first_name = "Jane"
    Faker::Lorem.stubs(:word).returns("changed")

    ActiveRecordAnonymizer::AttributesAnonymizer.new(@user).anonymize_columns

    assert_equal "changed", @user.first_name
    assert_equal "random_word", @user.last_name
    assert_equal "random_word", @user.email
  end

  test "#anonymize_columns should skip updating the record if skip_update is true" do
    @user.save!

    @user.first_name = "Jane"
    Faker::Lorem.stubs(:word).returns("changed")

    ActiveRecordAnonymizer::AttributesAnonymizer.new(@user, skip_update: true).anonymize_columns

    assert_equal "random_word", @user.first_name
    assert_equal "random_word", @user.last_name
    assert_equal "random_word", @user.email
  end

  test "#populate will anonymize all attributes and save the record" do
    ActiveRecordAnonymizer::AttributesAnonymizer.new(@user).populate

    assert @user.persisted?
    assert_equal "random_word", @user.first_name
    assert_equal "random_word", @user.last_name
    assert_equal "random_word", @user.email
  end
end
