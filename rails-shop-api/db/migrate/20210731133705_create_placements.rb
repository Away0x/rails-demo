class CreatePlacements < ActiveRecord::Migration[6.1]
  def change
    create_table :placements do |t|
      t.integer :order_id, null: false, default: 0
      t.integer :product_id, null: false, default: 0
      t.integer :quantity, null: false, default: 0

      t.timestamps

      t.index [:order_id, :product_id]
      t.index [:product_id, :order_id]
    end
  end
end
