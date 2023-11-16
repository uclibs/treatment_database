class AddOtherNoteToExternalRepairRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :external_repair_records, :other_note, :text
  end
end
