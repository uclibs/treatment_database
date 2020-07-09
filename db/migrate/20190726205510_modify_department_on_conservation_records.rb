# frozen_string_literal: true

class ModifyDepartmentOnConservationRecords < ActiveRecord::Migration[5.2]
  # This migration is in service of changing the department field
  # from a free-form text field to a controlled vocabulary.
  def up
    remove_column :conservation_records, :department
    add_column :conservation_records, :department, :integer
  end

  def down
    remove_column :conservation_records, :department
    add_column :conservation_records, :department, :string
  end
end
