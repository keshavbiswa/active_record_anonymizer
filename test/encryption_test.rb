# frozen_string_literal: true

require_relative "../test/test_helper"

class EncryptionTest < ActiveSupport::TestCase
  setup do
    @encrypted_user = EncryptedUser.create!(first_name: "John", last_name: "Doe", email: "test@example.com")
  end

  test "raise error when encryption is called on Rails version less than 7.0" do
    EncryptedUser.expects(:rails_version_supported?).returns(false)

    assert_raises(ActiveRecordAnonymizer::UnsupportedVersionError, match: "ActiveRecordAnonymizer relies on Rails 7+ for encrypted columns.") do
      EncryptedUser.anonymize(:first_name, :last_name, :email, encrypted: true)
    end
  end
end
