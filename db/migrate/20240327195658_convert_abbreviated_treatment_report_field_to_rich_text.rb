class ConvertAbbreviatedTreatmentReportFieldToRichText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper

  def up
    # Rename the original column to preserve the plain text data
    rename_column :treatment_reports, :abbreviated_treatment_report, :old_abbreviated_treatment_report

    # Add a new column for storing the rich text formatted content
    add_column :treatment_reports, :abbreviated_treatment_report, :text

    # Convert the content from plain to rich text and store it in the new column
    TreatmentReport.find_each do |report|
      formatted_content = simple_format(report.old_abbreviated_treatment_report)
      report.update_column(:abbreviated_treatment_report, formatted_content)
    end

    # We will need to remove the old column after we are sure that the new column is working as expected
    # This will be a separate PR:
    # remove_column :treatment_reports, :old_abbreviated_treatment_report
  end


    # Migration Irreversibility Notice
    # This migration transitions the abbreviated_treatment_report field from plain text
    # to rich text, in anticipation of future enhancements like image embedding. Given
    # the complexity of this transformation and to ensure data integrity, this migration
    # is designed to be irreversible. Reversing these changes is not straightforward and
    # may lead to significant data loss, especially once rich media is introduced. Should
    # a rollback be necessary, it should be approached with caution and likely requires
    # manual intervention alongside a comprehensive data restoration strategy from backups.
    # This design decision prioritizes future-proofing our application's content handling
    # capabilities.
    def down
      raise ActiveRecord::IrreversibleMigration, "Reverting this migration requires manual intervention and data restoration from backups."
    end
end
