class CreateStockTransferItems < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_transfer_items do |t|
      t.references :stock_transfer,
                   null: false,
                   foreign_key: true

      t.references :product,
                   null: false,
                   foreign_key: true

      t.integer :quantity,
                null: false

      t.timestamps
    end

    add_index :stock_transfer_items,
              [ :stock_transfer_id, :product_id ],
              unique: true
  end
end
