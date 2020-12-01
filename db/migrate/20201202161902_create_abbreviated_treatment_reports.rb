class CreateAbbreviatedTreatmentReports < ActiveRecord::Migration[5.2]
  def change
    create_table :abbreviated_treatment_reports do |t|
      t.references :conservation_record, foreign_key: true

      t.timestamps
    end
  end
end
