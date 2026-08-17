class RemoveDescriptionFromShops < ActiveRecord::Migration[8.1]
  def change
    remove_column :shops, :description, :text
  end
end
