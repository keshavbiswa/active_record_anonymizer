class CreateGeneratorTestModels < ActiveRecord::Migration[7.1]
  def change
    create_table :generator_test_models do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :about
      t.string :sex
      t.integer :age
      t.float :score
      t.datetime :last_online_at
      t.date :birth_date
      t.boolean :married
      t.json :settings

      t.timestamps
    end
  end
end
