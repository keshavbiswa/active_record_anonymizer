# frozen_string_literal: true

class InvalidAnonymizedArgumentsUser < ApplicationRecord
  anonymize :first_name, :last_name, :email, with: ->(record) { "anonymized #{record.first_name}" }, column_name: "anonymized_first_name"
end
