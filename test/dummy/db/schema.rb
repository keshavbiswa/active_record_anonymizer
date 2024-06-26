# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_15_144856) do
  create_table "encrypted_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "anonymized_first_name", default: ""
    t.string "anonymized_last_name", default: ""
    t.string "anonymized_email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generator_test_models", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "about"
    t.string "sex"
    t.integer "age"
    t.float "score"
    t.datetime "last_online_at"
    t.date "birth_date"
    t.boolean "married"
    t.json "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invalid_anonymized_arguments_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_with_custom_anonymizes", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "anonymized_first_name", default: ""
    t.string "anonymized_last_name", default: ""
    t.string "anonymized_email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_without_anonymize_methods", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "anonymized_first_name", default: ""
    t.string "anonymized_last_name", default: ""
    t.string "anonymized_email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_without_anonymized_columns", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anonymized_first_name", default: ""
    t.string "anonymized_last_name", default: ""
    t.string "anonymized_email", default: ""
  end

  create_table "validated_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "anonymized_first_name", default: ""
    t.string "anonymized_last_name", default: ""
    t.string "anonymized_email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
