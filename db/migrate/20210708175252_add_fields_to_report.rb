class AddFieldsToReport < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :start_date, :date
    add_column :reports, :end_date, :date
  end
end
