class CreateBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percent_discount
      t.integer :quantity_threshold
      t.references :merchant, foreign_key: true
    end
  end
end
