class AddDefaultValuesToAnonymizedAttributesInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :anonymized_first_name, from: nil, to: ""
    change_column_default :users, :anonymized_last_name, from: nil, to: ""
    change_column_default :users, :anonymized_email, from: nil, to: ""
  end
end
