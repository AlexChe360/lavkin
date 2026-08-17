module Storefront
  class CheckoutsController < BaseController
    def show
      load_cart_items

      redirect_to storefront_cart_path(
        shop_slug: @shop.slug
      ),
                  alert: "Корзина пуста" if @cart_items.empty?
    end

    def create
      load_cart_items

      if @cart_items.empty?
        redirect_to storefront_cart_path(
          shop_slug: @shop.slug
        ),
                    alert: "Корзина пуста"

        return
      end

      validate_stock!

      order =
        create_order!

      @cart.cart_items.destroy_all

      redirect_to storefront_order_path(
        shop_slug: @shop.slug,
        number: order.number
      )
    rescue ActiveRecord::RecordInvalid,
           ArgumentError => error

      @error_message =
        error.message

      render :show,
             status: :unprocessable_entity
    end

    private

    def load_cart_items
      @cart_items =
        @cart
          .cart_items
          .includes(
            product: {
              image_attachment: :blob
            }
          )
          .order(:created_at)
    end

    def checkout_params
      params
        .require(:checkout)
        .permit(
          :customer_name,
          :customer_phone,
          :customer_email
        )
    end

    def validate_stock!
      @cart_items.each do |item|
        available =
          InventoryLevel
            .where(product: item.product)
            .sum(:quantity)

        next if available >= item.quantity

        raise ArgumentError,
              "Недостаточно товара «#{item.product.name}»"
      end
    end

    def create_order!
      Order.transaction do
        order =
          @shop.orders.create!(
            number: generate_order_number,
            status: "awaiting_payment",
            customer_name: checkout_params[:customer_name],
            customer_phone: checkout_params[:customer_phone],
            customer_email: checkout_params[:customer_email],
            total_amount: @cart.total_price
          )

        @cart_items.each do |item|
          price =
            item.product.price

          order.order_items.create!(
            product: item.product,
            product_name: item.product.name,
            sku: item.product.sku,
            price: price,
            quantity: item.quantity,
            total_amount: price * item.quantity
          )
        end

        order
      end
    end

    def generate_order_number
      loop do
        number =
          "LVK-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.random_number(10_000).to_s.rjust(4, '0')}"

        break number unless @shop.orders.exists?(
          number: number
        )
      end
    end
  end
end
