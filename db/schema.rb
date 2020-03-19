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

ActiveRecord::Schema.define(version: 2020_01_24_174713) do

  create_table "conservation_records", force: :cascade do |t|
    t.date "date_recieved_in_preservation_services"
    t.string "title"
    t.string "author"
    t.string "imprint"
    t.string "call_number"
    t.string "item_record_number"
    t.boolean "digitization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department"
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

  create_table "treatment_reports", force: :cascade do |t|
    t.string "description_general_remarks"
    t.string "description_binding"
    t.string "description_textblock"
    t.string "description_primary_support"
    t.string "description_medium"
    t.string "description_attachments_inserts"
    t.string "description_housing"
    t.string "condition_summary"
    t.string "condition_binding"
    t.string "condition_textblock"
    t.string "condition_primary_support"
    t.string "condition_medium"
    t.integer "condition_housing_id"
    t.string "condition_housing_narrative"
    t.string "condition_attachments_inserts"
    t.string "condition_previous_treatment"
    t.string "condition_materials_analysis"
    t.string "treatment_proposal_proposal"
    t.integer "treatment_proposal_housing_need_id"
    t.string "treatment_proposal_factors_influencing_treatment"
    t.string "treatment_proposal_performed_treatment"
    t.integer "treatment_proposal_housing_provided_id"
    t.string "treatment_proposal_housing_narrative"
    t.string "treatment_proposal_storage_and_handling_notes"
    t.integer "treatment_proposal_total_treatment_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "conservation_record_id"
    t.index ["conservation_record_id"], name: "index_treatment_reports_on_conservation_record_id"
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
    t.string "role"
    t.boolean "account_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
