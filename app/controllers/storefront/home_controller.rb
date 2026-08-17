module Storefront
  class HomeController < BaseController
    layout "storefront"

    def show
      @shop =
        Shop
          .includes(
            :categories,
            products: [
              :category,
              { image_attachment: :blob }
            ]
          )
          .find_by!(
            slug: params[:shop_slug],
            status: :active
          )

      raise ActiveRecord::RecordNotFound unless @shop.storefront_published?

      @categories =
        @shop
          .categories
          .active
          .ordered

      @products =
        @shop
          .products
          .active
          .includes(
            :category,
            image_attachment: :blob
          )
          .order(:name)

      filter_by_category

      load_inventory_quantities

      filter_out_of_stock_products
    end

    private

    def filter_by_category
      return if params[:category].blank?

      category =
        @shop
          .categories
          .active
          .find_by!(
            slug: params[:category]
          )

      @products =
        @products.where(
          category: category
        )
    end

    def load_inventory_quantities
      @inventory_quantities =
        InventoryLevel
          .where(
            product_id: @products.select(:id)
          )
          .group(:product_id)
          .sum(:quantity)
    end

    def filter_out_of_stock_products
      return if @shop.storefront_show_out_of_stock?

      product_ids =
        @inventory_quantities
          .select do |_product_id, quantity|
            quantity.positive?
          end
          .keys

      @products =
        @products.where(
          id: product_ids
        )
    end
  end
end
