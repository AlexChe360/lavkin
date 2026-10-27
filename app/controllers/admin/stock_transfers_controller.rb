module Admin
  class StockTransfersController < AdminController
    before_action :require_admin!
    before_action :require_current_shop
    before_action :set_transfer,
                  only: %i[
                    show
                    complete
                  ]
    before_action :require_inventory_management!

    def index
      @transfers =
        Current.shop
               .stock_transfers
               .includes(
                 :source_location,
                 :destination_location
               )
               .order(created_at: :desc)
    end

    def show
      @items =
        @transfer
          .stock_transfer_items
          .includes(:product)
    end

    def new
      @transfer =
        Current.shop.stock_transfers.new

      @transfer.stock_transfer_items.build

      load_form_data
    end

    def create
      @transfer =
        Current.shop
               .stock_transfers
               .new(transfer_params)

      @transfer.number =
        generate_number

      if @transfer.save
        redirect_to admin_stock_transfer_path(@transfer),
                    notice: "Перемещение создано"
      else
        load_form_data

        render :new,
               status: :unprocessable_entity
      end
    end

    def complete
      Inventory::CompleteTransfer.call(
        transfer: @transfer
      )

      redirect_to admin_stock_transfer_path(@transfer),
                  notice: "Перемещение выполнено"
    rescue ArgumentError,
           ActiveRecord::RecordInvalid => error

      redirect_to admin_stock_transfer_path(@transfer),
                  alert: error.message
    end

    private

    def set_transfer
      @transfer =
        Current.shop
               .stock_transfers
               .find(params[:id])
    end

    def transfer_params
      params
        .require(:stock_transfer)
        .permit(
          :source_location_id,
          :destination_location_id,
          stock_transfer_items_attributes: [
            :product_id,
            :quantity
          ]
        )
    end

    def load_form_data
      @locations =
        Current.shop
               .locations
               .active
               .order(:name)

      @products =
        Current.shop
               .products
               .active
               .order(:name)
    end

    def generate_number
      "TR-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.random_number(10_000).to_s.rjust(4, '0')}"
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                  alert: "Сначала выберите магазин"
    end
  end
end
