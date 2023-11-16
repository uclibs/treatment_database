class ChangeStringColumnsToTextInTreatmentReports < ActiveRecord::Migration[5.2]
  def change
    # Description Fields
    change_column :treatment_reports, :description_general_remarks, :text
    change_column :treatment_reports, :description_binding, :text
    change_column :treatment_reports, :description_textblock, :text
    change_column :treatment_reports, :description_primary_support, :text
    change_column :treatment_reports, :description_medium, :text
    change_column :treatment_reports, :description_attachments_inserts, :text
    change_column :treatment_reports, :description_housing, :text
    # Condition Fields
    change_column :treatment_reports, :condition_summary, :text
    change_column :treatment_reports, :condition_binding, :text
    change_column :treatment_reports, :condition_textblock, :text
    change_column :treatment_reports, :condition_primary_support, :text
    change_column :treatment_reports, :condition_medium, :text
    change_column :treatment_reports, :condition_housing_narrative, :text
    change_column :treatment_reports, :condition_attachments_inserts, :text
    change_column :treatment_reports, :condition_previous_treatment, :text
    change_column :treatment_reports, :condition_materials_analysis, :text

    # Treatment Proposal Fields
    change_column :treatment_reports, :treatment_proposal_proposal, :text
    change_column :treatment_reports, :treatment_proposal_factors_influencing_treatment, :text
    change_column :treatment_reports, :treatment_proposal_performed_treatment, :text
    change_column :treatment_reports, :treatment_proposal_housing_narrative, :text
    change_column :treatment_reports, :treatment_proposal_storage_and_handling_notes, :text
    #Conservators note
    change_column :treatment_reports, :conservators_note, :text
  end
end
