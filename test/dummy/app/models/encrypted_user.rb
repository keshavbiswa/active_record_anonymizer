# frozen_string_literal: true

class EncryptedUser < ApplicationRecord
  anonymize :first_name, encrypted: true
  anonymize :last_name, encrypted: true
  anonymize :email
end
