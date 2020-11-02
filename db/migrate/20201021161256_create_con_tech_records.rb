class CreateConTechRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :con_tech_records do |t|
      t.integer :performed_by_user_id
      t.references :conservation_record, foreign_key: true

      t.timestamps
    end
  end
end
