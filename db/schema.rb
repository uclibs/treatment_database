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

ActiveRecord::Schema.define(version: 2024_03_07_145522) do

  create_table "abbreviated_treatment_reports", force: :cascade do |t|
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conservation_record_id"], name: "index_abbreviated_treatment_reports_on_conservation_record_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "con_tech_records", force: :cascade do |t|
    t.integer "performed_by_user_id"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conservation_record_id"], name: "index_con_tech_records_on_conservation_record_id"
  end

  create_table "conservation_records", force: :cascade do |t|
    t.date "date_received_in_preservation_services"
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
    t.boolean "favorite", default: false
  end

  create_table "cost_return_reports", force: :cascade do |t|
    t.decimal "shipping_cost", precision: 8, scale: 2
    t.decimal "repair_estimate", precision: 8, scale: 2
    t.decimal "repair_cost", precision: 8, scale: 2
    t.datetime "invoice_sent_to_business_office"
    t.boolean "complete"
    t.datetime "returned_to_origin"
    t.text "note"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conservation_record_id"], name: "index_cost_return_reports_on_conservation_record_id"
  end

  create_table "external_repair_records", force: :cascade do |t|
    t.integer "repair_type"
    t.integer "performed_by_vendor_id"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "other_note"
    t.index ["conservation_record_id"], name: "index_external_repair_records_on_conservation_record_id"
  end

  create_table "in_house_repair_records", force: :cascade do |t|
    t.integer "repair_type"
    t.integer "performed_by_user_id"
    t.integer "minutes_spent"
    t.integer "conservation_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "other_note"
    t.integer "staff_code_id"
    t.index ["conservation_record_id"], name: "index_in_house_repair_records_on_conservation_record_id"
    t.index ["staff_code_id"], name: "index_in_house_repair_records_on_staff_code_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "staff_codes", force: :cascade do |t|
    t.string "code"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treatment_reports", force: :cascade do |t|
    t.text "description_general_remarks"
    t.text "description_binding"
    t.text "description_textblock"
    t.text "description_primary_support"
    t.text "description_medium"
    t.text "description_attachments_inserts"
    t.text "description_housing"
    t.text "condition_summary"
    t.text "condition_binding"
    t.text "condition_textblock"
    t.text "condition_primary_support"
    t.text "condition_medium"
    t.integer "condition_housing_id"
    t.text "condition_housing_narrative"
    t.text "condition_attachments_inserts"
    t.text "condition_previous_treatment"
    t.text "condition_materials_analysis"
    t.text "treatment_proposal_proposal"
    t.integer "treatment_proposal_housing_need_id"
    t.text "treatment_proposal_factors_influencing_treatment"
    t.text "treatment_proposal_performed_treatment"
    t.integer "treatment_proposal_housing_provided_id"
    t.text "treatment_proposal_housing_narrative"
    t.text "treatment_proposal_storage_and_handling_notes"
    t.text "treatment_proposal_total_treatment_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "conservation_record_id"
    t.text "abbreviated_treatment_report"
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

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.integer "item_id", limit: 8, null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "abbreviated_treatment_reports", "conservation_records"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "con_tech_records", "conservation_records"
  add_foreign_key "cost_return_reports", "conservation_records"
  add_foreign_key "external_repair_records", "conservation_records"
  add_foreign_key "in_house_repair_records", "conservation_records"
  add_foreign_key "in_house_repair_records", "staff_codes"
  add_foreign_key "treatment_reports", "conservation_records"
end
