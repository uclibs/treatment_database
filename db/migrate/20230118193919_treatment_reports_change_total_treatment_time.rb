class TreatmentReportsChangeTotalTreatmentTime < ActiveRecord::Migration[5.2]
  def change  
    change_column(:treatment_reports, :treatment_proposal_total_treatment_time, :text)
  end
end
