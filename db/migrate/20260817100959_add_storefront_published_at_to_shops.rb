class AddStorefrontPublishedAtToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :storefront_published_at, :datetime
  end
end
