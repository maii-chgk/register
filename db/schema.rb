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

ActiveRecord::Schema[7.1].define(version: 2024_06_17_204740) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "assemblies", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "currency", default: "EUR"
    t.decimal "amount", precision: 8, scale: 2
    t.integer "method", default: 0
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "cyrillic_name"
    t.date "start_date"
    t.boolean "accepted", default: false
    t.datetime "end_date", precision: nil
    t.boolean "newsletter", default: false
    t.string "discourse_username"
    t.integer "discourse_id"
    t.boolean "suspended"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.datetime "created_at", precision: nil
    t.json "object"
    t.json "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "date", precision: nil
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "voting_session_id"
    t.integer "assembly_id"
    t.integer "voting_topic_id"
    t.index ["voting_topic_id"], name: "index_votes_on_voting_topic_id"
  end

  create_table "voting_sessions", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voting_topics", force: :cascade do |t|
    t.integer "topic_id"
    t.integer "assembly_id"
    t.integer "voting_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assembly_id"], name: "index_voting_topics_on_assembly_id"
    t.index ["voting_session_id"], name: "index_voting_topics_on_voting_session_id"
  end

  add_foreign_key "votes", "voting_topics"
  add_foreign_key "voting_topics", "assemblies"
  add_foreign_key "voting_topics", "voting_sessions"
end
