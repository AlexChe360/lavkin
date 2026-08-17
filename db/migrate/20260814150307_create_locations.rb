class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.references :shop, null: false, foreign_key: true

      t.string :name, null: false

      t.string :code, null: false

      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :locations,
              [ :shop_id, :code ],
              unique: true
  end
end
