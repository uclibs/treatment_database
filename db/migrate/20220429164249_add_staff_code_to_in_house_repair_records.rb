class AddStaffCodeToInHouseRepairRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :in_house_repair_records, :staff_code, foreign_key: true
  end
end
