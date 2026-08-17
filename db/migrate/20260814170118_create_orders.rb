class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :shop,
                   null: false,
                   foreign_key: true

      t.string :number,
               null: false

      t.string :status,
               null: false,
               default: "pending"

      t.string :customer_name
      t.string :customer_phone
      t.string :customer_email

      t.decimal :total_amount,
                precision: 12,
                scale: 2,
                null: false,
                default: 0

      t.timestamps
    end

    add_index :orders,
              [ :shop_id, :number ],
              unique: true
  end
end
