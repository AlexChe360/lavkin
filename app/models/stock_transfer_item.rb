class StockTransferItem < ApplicationRecord
  belongs_to :stock_transfer
  belongs_to :product

  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validate :product_belongs_to_shop

  private

  def product_belongs_to_shop
    return if product.blank? ||
              stock_transfer.blank?

    return if product.shop_id ==
              stock_transfer.shop_id

    errors.add(
      :product,
      "не принадлежит магазину"
    )
  end
end
