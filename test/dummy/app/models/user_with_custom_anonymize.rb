# frozen_string_literal: true

class UserWithCustomAnonymize < ApplicationRecord
  anonymize :first_name, with: ->(_record) { Faker::Name.male_first_name }
  anonymize :last_name, with: :anonymize_last_name
  anonymize :email, with: ->(record) { "#{record.first_name}@example.com" }

  private

  def anonymize_last_name
    Faker::Name.male_last_name
  end
end
