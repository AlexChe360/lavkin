class CreateInventoryCountItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_count_items do |t|
      t.references :inventory_count,
                   null: false,
                   foreign_key: true

      t.references :product,
                   null: false,
                   foreign_key: true

      t.integer :expected_quantity,
                null: false,
                default: 0

      t.integer :actual_quantity

      t.timestamps
    end

    add_index :inventory_count_items,
              [ :inventory_count_id, :product_id ],
              unique: true
  end
end
