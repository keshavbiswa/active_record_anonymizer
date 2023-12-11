# frozen_string_literal: true

class UserWithoutAnonymizedColumn < ApplicationRecord
  anonymize :first_name, :last_name, :email
end
