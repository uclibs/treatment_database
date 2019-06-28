# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_27_193616) do

  create_table "conservation_records", force: :cascade do |t|
    t.date "date_recieved_in_preservation_services"
    t.integer "department_id"
    t.string "title"
    t.string "author"
    t.string "imprint"
    t.string "call_number"
    t.string "item_record_number"
    t.boolean "digitization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "conservator_note"
  end

  create_table "controlled_vocabularies", force: :cascade do |t|
    t.string "vocabulary"
    t.string "key"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "external_repair_records", force: :cascade do |t|
    t.integer "repair_type"
    t.integer "performed_by_vendor_id"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conservation_record_id"], name: "index_external_repair_records_on_conservation_record_id"
  end

  create_table "in_house_repair_records", force: :cascade do |t|
    t.integer "repair_type"
    t.integer "performed_by_user_id"
    t.integer "minutes_spent"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conservation_record_id"], name: "index_in_house_repair_records_on_conservation_record_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
