class CreateInventoryCounts < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_counts do |t|
      t.references :shop,
                   null: false,
                   foreign_key: true

      t.references :location,
                   null: false,
                   foreign_key: true

      t.string :number,
               null: false

      t.string :status,
               null: false,
               default: "draft"

      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :inventory_counts,
              [ :shop_id, :number ],
              unique: true
  end
end
