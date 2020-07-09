class CreateCostReturnReports < ActiveRecord::Migration[5.2]
  def change
    create_table :cost_return_reports do |t|
      # Description Fields
      t.decimal :shipping_cost, precision: 8, scale: 2
      t.decimal :repair_estimate, precision: 8, scale: 2
      t.decimal :repair_cost, precision: 8, scale: 2
      t.datetime :invoice_sent_to_business_office
      t.boolean :complete
      t.datetime :returned_to_origin
      t.text :note
      t.references :conservation_record, foreign_key: true

      t.timestamps
    end
  end
end
