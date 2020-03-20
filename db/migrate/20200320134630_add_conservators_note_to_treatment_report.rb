class AddConservatorsNoteToTreatmentReport < ActiveRecord::Migration[5.2]
  def change
    add_column :treatment_reports, :conservators_note, :string
  end
end
