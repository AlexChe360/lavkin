class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :shop, null: false, foreign_key: true

      t.references :category, null: false, foreign_key: true

      t.string :name, null: false

      t.string :slug, null: false

      t.string :sku, null: false

      t.decimal :price, precision: 12, scale: 2, null: false

      t.decimal :compare_at_price, precision: 12, scale: 2

      t.boolean :active, null: false, default: true

      t.boolean :featured, null: false, default: false

      t.timestamps
    end

    add_index :products,
              [ :shop_id, :slug ],
              unique: true

    add_index :products,
              [ :shop_id, :sku ],
              unique: true
  end
end
