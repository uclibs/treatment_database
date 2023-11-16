class CreateStaffCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :staff_codes do |t|
      t.string :code
      t.integer :points

      t.timestamps
    end
  end
end
