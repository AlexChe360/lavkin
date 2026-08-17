class InventoryCountItem < ApplicationRecord
  belongs_to :inventory_count
  belongs_to :product

  validates :expected_quantity,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :actual_quantity,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validate :product_belongs_to_shop

  def difference
    return nil if actual_quantity.nil?

    actual_quantity - expected_quantity
  end

  private

  def product_belongs_to_shop
    return if product.blank? ||
              inventory_count.blank?

    return if product.shop_id ==
              inventory_count.shop_id

    errors.add(
      :product,
      "не принадлежит магазину"
    )
  end
end
