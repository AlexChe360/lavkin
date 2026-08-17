class AddCheckoutSettingsToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops,
           :storefront_accept_orders,
           :boolean,
           null: false,
           default: true

    add_column :shops,
              :storefront_pickup_enabled,
              :boolean,
              null: false,
              default: true

    add_column :shops,
              :storefront_delivery_enabled,
              :boolean,
              null: false,
              default: false
  end
end
