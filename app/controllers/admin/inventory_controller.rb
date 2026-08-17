module Admin
  class InventoryController < AdminController
    before_action :require_current_shop
    before_action :require_manager!

    def index
      @locations =
        Current.shop
                .locations
                .active
                .order(:name)

      @location =
        selected_location

      @products =
        Current.shop
                .products
                .includes(
                  :category,
                  image_attachment: :blob
                )
                .order(:name)

      apply_search

      @inventory_levels =
        if @location
          InventoryLevel
            .where(
              location: @location,
              product_id: @products.select(:id)
            )
            .index_by(&:product_id)
        else
          {}
        end
    end

    private

    def selected_location
      if params[:location_id].present?
        Current.shop
                .locations
                .find(params[:location_id])
      else
        @locations.first
      end
    end

    def apply_search
      return if params[:q].blank?

      query =
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].strip)}%"

      @products =
        @products.where(
          "products.name ILIKE :query OR products.sku ILIKE :query",
          query: query
        )
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
          alert: "Сначала выберите магазин"
    end
  end
end
