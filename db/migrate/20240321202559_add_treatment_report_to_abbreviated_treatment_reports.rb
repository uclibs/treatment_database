class AddTreatmentReportToAbbreviatedTreatmentReports < ActiveRecord::Migration[6.1]
  def change
    add_reference :abbreviated_treatment_reports, :treatment_report, foreign_key: true

    # Update existing records to set treatment_report_id
    AbbreviatedTreatmentReport.where(treatment_report_id: nil).each do |atr|
      conservation_record = atr.conservation_record
      treatment_report = conservation_record.treatment_report

      # Set treatment_report_id if treatment_report exists
      if treatment_report
        atr.update(treatment_report_id: treatment_report.id)
        puts "Added TreatmentReport foreign key for AbbreviatedTreatmentReport #{atr.id}"
      else
        raise StandardError, "No treatment report found for AbbreviatedTreatmentReport ID: #{atr.id}"
      end
    end
  end
end
