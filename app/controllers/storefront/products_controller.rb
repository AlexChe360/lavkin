module Storefront
  class ProductsController < BaseController
    def show
      @product =
        @shop
          .products
          .active
          .includes(
            :category,
            image_attachment: :blob
          )
          .find_by!(
            slug: params[:slug]
          )

      @total_quantity =
        InventoryLevel
          .where(
            product: @product
          )
          .sum(:quantity)
    end
  end
end
