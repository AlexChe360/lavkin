module Storefront
  class CartItemsController < BaseController
    before_action :set_product,
                  only: :create

    before_action :set_cart_item,
                  only: %i[
                    update
                    destroy
                    increment
                    decrement
                  ]

    def create
      available = available_quantity(@product)

      if available <= 0
        respond_to do |format|
          format.turbo_stream do
            head :unprocessable_entity
          end

          format.html do
            redirect_back(
              fallback_location:
                storefront_root_path(
                  shop_slug: @shop.slug
                ),
              alert: "Товара нет в наличии"
            )
          end
        end

        return
      end

      @cart_item =
        @cart.cart_items.find_by(
          product: @product
        )

      if @cart_item.present?
        @cart_item.update!(
          quantity: [
            @cart_item.quantity + 1,
            available
          ].min
        )
      else
        @cart_item =
          @cart.cart_items.create!(
            product: @product,
            quantity: 1
          )
      end

      @inventory_quantity = available

      respond_to do |format|
        format.turbo_stream

        format.html do
          redirect_back(
            fallback_location:
              storefront_root_path(
                shop_slug: @shop.slug
              )
          )
        end
      end
    end

    def update
      quantity =
        params[:quantity].to_i

      quantity = 1 if quantity < 1

      available =
        available_quantity(
          @cart_item.product
        )

      quantity =
        [
          quantity,
          available
        ].min

      @cart_item.update!(
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
      @product = @cart_item.product
      @inventory_quantity =
        available_quantity(@product)

      @cart_item.destroy!

      respond_to do |format|
        format.turbo_stream

        format.html do
          redirect_to storefront_cart_path(
            shop_slug: @shop.slug
          )
        end
      end
    end

    def increment
      @product = @cart_item.product

      @inventory_quantity =
        available_quantity(@product)

      new_quantity =
        [
          @cart_item.quantity + 1,
          @inventory_quantity
        ].min

      @cart_item.update!(
        quantity: new_quantity
      )

      respond_to do |format|
        format.turbo_stream

        format.html do
          redirect_to storefront_cart_path(
            shop_slug: @shop.slug
          )
        end
      end
    end

    def decrement
      @product = @cart_item.product

      @inventory_quantity =
        available_quantity(@product)

      if @cart_item.quantity <= 1
        @cart_item.destroy!
      else
        @cart_item.update!(
          quantity: @cart_item.quantity - 1
        )
      end

      respond_to do |format|
        format.turbo_stream

        format.html do
          redirect_to storefront_cart_path(
            shop_slug: @shop.slug
          )
        end
      end
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
          .find(
            params[:cart_item_id] || params[:id]
          )
    end

    def available_quantity(product)
      InventoryLevel
        .where(product: product)
        .sum(:quantity)
    end
  end
end
