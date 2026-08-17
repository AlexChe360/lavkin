module Admin
  class OrdersController < AdminController
    before_action :require_manager!
    before_action :require_current_shop
    before_action :set_order,
                  only: %i[
                    show
                    mark_as_paid
                    change_status
                    cancel
                  ]

    def index
      @orders =
        Current.shop
               .orders
               .includes(:order_items)
               .order(created_at: :desc)
    end

    def show
    end

    def mark_as_paid
      Order.transaction do
        @order.update!(
          status: "paid"
        )

        Orders::CommitInventory.call(
          order: @order
        )
      end

      redirect_to admin_order_path(@order),
                  notice: "Заказ отмечен как оплаченный"
    rescue ArgumentError,
        ActiveRecord::RecordInvalid => error
      redirect_to admin_order_path(@order),
                  alert: error.message
    end

    def change_status
      new_status =
        params.require(:status)

      unless Order::STATUSES.include?(new_status)
        redirect_to admin_order_path(@order),
                    alert: "Недопустимый статус"
        return
      end

      @order.update!(
        status: new_status
      )

      redirect_to admin_order_path(@order),
              notice: "Статус заказа обновлён"
    end

    def cancel
      Orders::Cancel.call(
        order: @order
      )

      redirect_to admin_order_path(@order),
                notice: "Заказ отменен"
    rescue ArgumentError,
        ActiveRecord::RecordInvalid => error

      redirect_to admin_order_path(@order),
                alert: error.message
    end

    private

    def set_order
      @order =
        Current.shop
               .orders
               .includes(:order_items)
               .find(params[:id])
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                  alert: "Сначала выберите магазин"
    end
  end
end
