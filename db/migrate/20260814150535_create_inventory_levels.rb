class CreateInventoryLevels < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_levels do |t|
      t.references :product, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end

    add_index :inventory_levels,
              [ :product_id, :location_id ],
              unique: true
  end
end
