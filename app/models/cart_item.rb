class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validate :product_belongs_to_cart_shop

  private

  def product_belongs_to_cart_shop
    return if cart.blank? || product.blank?

    return if product.shop_id == cart.shop_id

    errors.add(
      :product,
      "не принадлежит магазину корзины"
    )
  end
end
