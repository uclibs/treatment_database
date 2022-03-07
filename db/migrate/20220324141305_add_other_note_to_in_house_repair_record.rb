class AddOtherNoteToInHouseRepairRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :in_house_repair_records, :other_note, :text
  end
end
