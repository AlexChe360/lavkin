module Storefront
  class OrdersController < BaseController
    def show
      @order =
        @shop
          .orders
          .includes(
            order_items: :product
          )
          .find_by!(
            number: params[:number]
          )
    end
  end
end
