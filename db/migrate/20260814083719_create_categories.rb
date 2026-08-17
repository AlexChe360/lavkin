class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.references :shop, null: false, foreign_key: true

      t.string :name, null: false

      t.string :slug, null: false

      t.text :description

      t.integer :position, null: false, default: 0

      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :categories,
              [ :shop_id, :slug ],
              unique: true

    add_index :categories,
              [ :shop_id, :position ]
  end
end
