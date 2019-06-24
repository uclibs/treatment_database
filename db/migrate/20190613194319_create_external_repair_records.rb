# frozen_string_literal: true

class CreateExternalRepairRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :external_repair_records do |t|
      t.integer :repair_type
      t.integer :performed_by_vendor_id
      t.references :conservation_record, foreign_key: true

      t.timestamps
    end
  end
end
