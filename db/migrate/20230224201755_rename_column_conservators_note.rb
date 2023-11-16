class RenameColumnConservatorsNote < ActiveRecord::Migration[6.1]
  def change
    rename_column :treatment_reports, :conservators_note, :abbreviated_treatment_report
  end
end
