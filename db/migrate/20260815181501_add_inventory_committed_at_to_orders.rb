class AddInventoryCommittedAtToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :inventory_committed_at, :datetime
  end
end
