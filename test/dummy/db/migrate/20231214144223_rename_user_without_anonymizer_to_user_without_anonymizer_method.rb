class RenameUserWithoutAnonymizerToUserWithoutAnonymizerMethod < ActiveRecord::Migration[7.1]
  def change
    rename_table :user_without_anonymizers, :user_without_anonymize_methods
  end
end
