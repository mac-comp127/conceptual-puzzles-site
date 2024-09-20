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

ActiveRecord::Schema[7.2].define(version: 2024_09_20_035725) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "attempt_score", ["no_credit", "half_credit", "full_credit"]
  create_enum "attempt_state", ["queued", "available", "submitted", "graded"]

  create_table "attempts", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "puzzle_type_id", null: false
    t.enum "state", default: "queued", null: false, enum_type: "attempt_state"
    t.text "content"
    t.enum "score", enum_type: "attempt_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_type_id"], name: "index_attempts_on_puzzle_type_id"
    t.index ["student_id"], name: "index_attempts_on_student_id"
  end

  create_table "puzzle_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_puzzle_types_on_name", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "attempts", "puzzle_types"
  add_foreign_key "attempts", "students"
end
