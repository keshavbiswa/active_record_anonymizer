class CreateUserWithoutAnonymizedColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :user_without_anonymized_columns do |t|
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end
