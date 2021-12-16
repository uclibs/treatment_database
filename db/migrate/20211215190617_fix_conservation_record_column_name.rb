# frozen_string_literal: true

class FixConservationRecordColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :conservation_records, :date_recieved_in_preservation_services, :date_received_in_preservation_services
  end
end
