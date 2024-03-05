# frozen_string_literal: true

require_relative "../../test/test_helper"

class ActiveRecordAnonymizer::EncryptorTest < ActiveSupport::TestCase
  setup do
    @encryptor = ActiveRecordAnonymizer::Encryptor.new(UserWithoutAnonymizeMethod, %i[first_name last_name email])
  end

  test "raise error when encryption is called on Rails version less than 7.0" do
    ActiveRecordAnonymizer::Encryptor.any_instance.stubs(:rails_version_supported?).returns(false)

    assert_raises(ActiveRecordAnonymizer::UnsupportedVersionError, match: "ActiveRecordAnonymizer relies on Rails 7+ for encrypted columns.") do
      @encryptor.encrypt
    end
  end

  test "encrypts columns" do
    user = UserWithoutAnonymizeMethod.new(first_name: "John", last_name: "Doe", email: "test@example.com")
    user.save!

    assert_equal "John", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "test@example.com", user.email

    @encryptor.encrypt

    assert_equal user.encrypted_attributes.to_a, %i[first_name last_name email]
  end
end
