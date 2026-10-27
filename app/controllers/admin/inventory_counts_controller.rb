module Admin
  class InventoryCountsController < AdminController
    before_action :require_admin!
    before_action :require_current_shop
    before_action :set_inventory_count,
                  only: %i[
                    show
                    update
                    start
                    complete
                  ]
    before_action :require_inventory_management!

    def index
      @inventory_counts =
        Current.shop
               .inventory_counts
               .includes(:location)
               .order(created_at: :desc)
    end

    def show
      @items =
        @inventory_count
          .inventory_count_items
          .includes(:product)
          .order("products.name")
    end

    def new
      @inventory_count =
        Current.shop.inventory_counts.new

      @locations =
        Current.shop
               .locations
               .active
               .order(:name)
    end

    def create
      @inventory_count =
        Current.shop
               .inventory_counts
               .new(inventory_count_params)

      @inventory_count.number =
        generate_number

      if @inventory_count.save
        redirect_to admin_inventory_count_path(@inventory_count),
                    notice: "Инвентаризация создана"
      else
        @locations =
          Current.shop
                 .locations
                 .active
                 .order(:name)

        render :new,
               status: :unprocessable_entity
      end
    end

    def update
      if @inventory_count.update(items_params)
        redirect_to admin_inventory_count_path(@inventory_count),
                    notice: "Фактические остатки сохранены"
      else
        @items =
          @inventory_count
            .inventory_count_items
            .includes(:product)

        render :show,
               status: :unprocessable_entity
      end
    end

    def start
      Inventory::StartCount.call(
        inventory_count: @inventory_count
      )

      redirect_to admin_inventory_count_path(@inventory_count),
                  notice: "Инвентаризация начата"
    rescue ArgumentError,
           ActiveRecord::RecordInvalid => error

      redirect_to admin_inventory_count_path(@inventory_count),
                  alert: error.message
    end

    def complete
      Inventory::CompleteCount.call(
        inventory_count: @inventory_count
      )

      redirect_to admin_inventory_count_path(@inventory_count),
                  notice: "Инвентаризация завершена"
    rescue ArgumentError,
           ActiveRecord::RecordInvalid => error

      redirect_to admin_inventory_count_path(@inventory_count),
                  alert: error.message
    end

    private

    def set_inventory_count
      @inventory_count =
        Current.shop
               .inventory_counts
               .find(params[:id])
    end

    def inventory_count_params
      params
        .require(:inventory_count)
        .permit(
          :location_id
        )
    end

    def items_params
      params
        .require(:inventory_count)
        .permit(
          inventory_count_items_attributes: [
            :id,
            :actual_quantity
          ]
        )
    end

    def generate_number
      "INV-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.random_number(10_000).to_s.rjust(4, '0')}"
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                  alert: "Сначала выберите магазин"
    end
  end
end
