module Admin
  class InventoryAdjustmentsController < AdminController
    before_action :require_current_shop
    before_action :set_product
    before_action :set_location
    before_action :require_inventory_management!

    def new
      @inventory_level =
        InventoryLevel.find_or_initialize_by(
          product: @product,
          location: @location
        )
    end

    def create
      Inventory::AdjustStock.call(
        product: @product,
        location: @location,
        quantity: adjustment_params[:quantity],
        comment: adjustment_params[:comment]
      )

      redirect_to admin_inventory_path(
        location_id: @location.id
      ),
                  notice: "Остаток обновлён"
    rescue ArgumentError,
           ActiveRecord::RecordInvalid => error

      @inventory_level =
        InventoryLevel.find_or_initialize_by(
          product: @product,
          location: @location
        )

      @error_message =
        error.message

      render :new,
             status: :unprocessable_entity
    end

    private

    def set_product
      @product =
        Current.shop
               .products
               .find(params[:product_id])
    end

    def set_location
      @location =
        Current.shop
               .locations
               .find(params[:location_id])
    end

    def adjustment_params
      params
        .require(:inventory_adjustment)
        .permit(
          :quantity,
          :comment
        )
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                  alert: "Сначала выберите магазин"
    end
  end
end
