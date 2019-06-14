class CreateConservationRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :conservation_records do |t|
      t.date :date_recieved_in_preservation_services
      t.string :department
      t.string :title
      t.string :author
      t.string :imprint
      t.string :call_number
      t.string :item_record_number
      t.boolean :digitization

      t.timestamps
    end
  end
end
