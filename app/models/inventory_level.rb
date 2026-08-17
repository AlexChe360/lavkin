class InventoryLevel < ApplicationRecord
  belongs_to :product
  belongs_to :location

  validates :product_id,
            uniqueness: {
              scope: :location_id
            }

  validates :quantity,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 0
              }
end
