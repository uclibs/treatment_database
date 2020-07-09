# frozen_string_literal: true

class CreateTreatmentReports < ActiveRecord::Migration[5.2]
  def change # rubocop:todo Metrics/AbcSize
    create_table :treatment_reports do |t| # rubocop:todo Metrics/BlockLength
      # Description Fields
      t.string :description_general_remarks
      t.string :description_binding
      t.string :description_textblock
      t.string :description_primary_support
      t.string :description_medium
      t.string :description_attachments_inserts
      t.string :description_housing

      # Condition Fields
      t.string :condition_summary
      t.string :condition_binding
      t.string :condition_textblock
      t.string :condition_primary_support
      t.string :condition_medium
      t.integer :condition_housing_id
      t.string :condition_housing_narrative
      t.string :condition_attachments_inserts
      t.string :condition_previous_treatment
      t.string :condition_materials_analysis

      # Treatment Proposal Fields
      t.string :treatment_proposal_proposal
      t.integer :treatment_proposal_housing_need_id
      t.string :treatment_proposal_factors_influencing_treatment
      t.string :treatment_proposal_performed_treatment
      t.integer :treatment_proposal_housing_provided_id
      t.string :treatment_proposal_housing_narrative
      t.string :treatment_proposal_storage_and_handling_notes
      t.integer :treatment_proposal_total_treatment_time

      t.timestamps
    end
  end
end
