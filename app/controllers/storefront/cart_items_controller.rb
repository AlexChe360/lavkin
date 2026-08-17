module Storefront
  class CartItemsController < BaseController
    before_action :set_product,
                  only: :create

    before_action :set_cart_item,
                  only: %i[
                    update
                    destroy
                  ]

    def create
      available =
        InventoryLevel
          .where(product: @product)
          .sum(:quantity)

      if available <= 0
        redirect_back(
          fallback_location:
            storefront_root_path(
              shop_slug: @shop.slug
            ),
          alert: "Товара нет в наличии"
        )

        return
      end

      item =
        @cart.cart_items.find_by(
          product: @product
        )

      if item.present?
        new_quantity =
          [ item.quantity + 1, available ].min

        item.update!(
          quantity: new_quantity
        )
      else
        @cart.cart_items.create!(
          product: @product,
          quantity: 1
        )
      end

      redirect_back(
        fallback_location:
          storefront_root_path(
            shop_slug: @shop.slug
          ),
        notice: "Товар добавлен в корзину"
      )
    end

    def update
      item =
        @cart
          .cart_items
          .find(params[:id])

      quantity =
        params[:quantity].to_i

      if quantity < 1
        quantity = 1
      end

      item.update!(
        quantity: quantity
      )

      redirect_to storefront_cart_path(
                    shop_slug: @shop.slug
                  ),
                  status: :see_other

    rescue ActiveRecord::RecordNotFound
      redirect_to storefront_cart_path(
                    shop_slug: @shop.slug
                  ),
                  alert: "Товар в корзине не найден",
                  status: :see_other
    end

    def destroy
      @cart_item.destroy!

      redirect_to storefront_cart_path(
        shop_slug: @shop.slug
      )
    end

    private

    def set_product
      @product =
        @shop
          .products
          .active
          .find(params[:product_id])
    end

    def set_cart_item
      @cart_item =
        @cart
          .cart_items
          .find(params[:id])
    end
  end
end
