module Storefront
  class CartsController < BaseController
    def show
      @cart_items =
        @cart
          .cart_items
          .includes(
            product: {
              image_attachment: :blob
            }
          )
          .order(created_at: :asc)
    end
  end
end
