class CreateStockTransfers < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_transfers do |t|
      t.references :shop,
                   null: false,
                   foreign_key: true

      t.references :source_location,
                   null: false,
                   foreign_key: {
                     to_table: :locations
                   }

      t.references :destination_location,
                   null: false,
                   foreign_key: {
                     to_table: :locations
                   }

      t.string :number,
               null: false

      t.string :status,
               null: false,
               default: "draft"

      t.datetime :completed_at

      t.timestamps
    end

    add_index :stock_transfers,
              [ :shop_id, :number ],
              unique: true
  end
end
