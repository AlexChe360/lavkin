class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order,
                   null: false,
                   foreign_key: true

      t.references :product,
                   null: true,
                   foreign_key: true

      t.string :product_name,
               null: false

      t.string :sku,
               null: false

      t.decimal :price,
                precision: 12,
                scale: 2,
                null: false

      t.integer :quantity,
                null: false

      t.decimal :total_amount,
                precision: 12,
                scale: 2,
                null: false

      t.timestamps
    end
  end
end
