# frozen_string_literal: true

class CreateInHouseRepairRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :in_house_repair_records do |t|
      t.integer :repair_type
      t.integer :performed_by_user_id
      t.integer :minutes_spent
      t.references :conservation_record, foreign_key: true

      t.timestamps
    end
  end
end
