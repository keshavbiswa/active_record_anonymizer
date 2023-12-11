# frozen_string_literal: true

class AddAnonymizedColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :anonymized_first_name, :string
    add_column :users, :anonymized_last_name, :string
    add_column :users, :anonymized_email, :string
  end
end
