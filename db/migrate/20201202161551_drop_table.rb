class DropTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :abbreviated_treatment_reports
  end
end
