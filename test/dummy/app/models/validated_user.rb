# frozen_string_literal: true

class ValidatedUser < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  anonymize :first_name, :last_name, :email
end
