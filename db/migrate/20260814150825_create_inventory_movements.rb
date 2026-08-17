class CreateInventoryMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.integer :quantity_change, null: false
      t.string :operation, null: false
      t.string :comment

      t.timestamps
    end

    add_index :inventory_movements,
              [ :product_id, :created_at ]

    add_index :inventory_movements,
              [ :location_id, :created_at ]
  end
end
