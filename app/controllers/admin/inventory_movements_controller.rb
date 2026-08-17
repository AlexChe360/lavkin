module Admin
  class InventoryMovementsController < AdminController
    before_action :require_current_shop
    before_action :require_manager!

    def index
      @locations =
        Current.shop
               .locations
               .order(:name)

      @movements =
        InventoryMovement
          .joins(:product, :location)
          .where(
            products: {
              shop_id: Current.shop.id
            }
          )
          .includes(
            :product,
            :location
          )
          .order(created_at: :desc)

      apply_location_filter
      apply_operation_filter
      apply_search
    end

    private

    def apply_location_filter
      return if params[:location_id].blank?

      location =
        Current.shop
               .locations
               .find(params[:location_id])

      @movements =
        @movements.where(
          location: location
        )
    end

    def apply_operation_filter
      return if params[:operation].blank?

      @movements =
        @movements.where(
          operation: params[:operation]
        )
    end

    def apply_search
      return if params[:q].blank?

      query =
        "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].strip)}%"

      @movements =
        @movements.where(
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
