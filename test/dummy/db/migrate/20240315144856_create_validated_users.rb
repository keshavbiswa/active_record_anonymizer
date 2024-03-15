class CreateValidatedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :validated_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :anonymized_first_name, default: ""
      t.string :anonymized_last_name, default: ""
      t.string :anonymized_email, default: ""

      t.timestamps
    end
  end
end
