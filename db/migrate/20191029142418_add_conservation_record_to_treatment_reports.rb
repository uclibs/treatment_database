class AddConservationRecordToTreatmentReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :treatment_reports, :conservation_record, foreign_key: true
  end
end
