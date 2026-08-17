class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :shop, null: false, foreign_key: true
      t.string :token,
               null: false

      t.timestamps
    end

    add_index :carts,
              :token,
              unique: true
  end
end
