class AddContentToAbbreviatedTreatmentReports < ActiveRecord::Migration[6.1]
  def change
    add_column :abbreviated_treatment_reports, :content, :text
    add_column :abbreviated_treatment_reports, :content_html, :text
  end
end
