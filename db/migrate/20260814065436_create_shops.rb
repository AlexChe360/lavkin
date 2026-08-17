class CreateShops < ActiveRecord::Migration[8.1]
  def change
    create_table :shops do |t|
      t.references :account, null: false, foreign_key: true

      t.string :name, null: false

      t.string :slug, null: false

      t.text :description

      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :shops,
              :slug,
              unique: true
  end
end
