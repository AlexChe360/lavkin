class Cart < ApplicationRecord
  belongs_to :shop

  has_many :cart_items,
           dependent: :destroy

  has_many :products,
           through: :cart_items

  validates :token,
            presence: true,
            uniqueness: true

  def total_quantity
    cart_items.sum(:quantity)
  end

  def total_price
    cart_items.includes(:product).sum do |item|
      item.product.price * item.quantity
    end
  end
end
