module Admin
  class LocationsController < AdminController
    before_action :require_current_shop
    before_action :set_location,
                  only: %i[
                    edit
                    update
                    destroy
                  ]
    before_action :require_inventory_management!,
                  only: %i[
                    new
                    create
                    edit
                    update
                    destroy
                  ]

    def index
      @locations =
        Current.shop
               .locations
               .order(
                 active: :desc,
                 name: :asc
               )
    end

    def new
      @location =
        Current.shop.locations.new
    end

    def create
      @location =
        Current.shop
               .locations
               .new(location_params)

      if @location.save
        redirect_to admin_locations_path,
                    notice: "Склад создан"
      else
        render :new,
               status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @location.update(location_params)
        redirect_to admin_locations_path,
                    notice: "Склад обновлён"
      else
        render :edit,
               status: :unprocessable_entity
      end
    end

    def destroy
      if @location.inventory_movements.exists?
        redirect_to admin_locations_path,
                    alert: "Нельзя удалить склад с историей движений"
        return
      end

      @location.destroy!

      redirect_to admin_locations_path,
                  notice: "Склад удалён"
    end

    private

    def set_location
      @location =
        Current.shop
               .locations
               .find(params[:id])
    end

    def location_params
      params
        .require(:location)
        .permit(
          :name,
          :code,
          :active
        )
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                  alert: "Сначала выберите магазин"
    end
  end
end
