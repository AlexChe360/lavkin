class AddStorefrontSettingsToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :storefront_description, :text
    add_column :shops, :storefront_show_out_of_stock, :boolean, null: false, default: false
  end
end
