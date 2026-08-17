module Orders
  class Cancel
    def self.call(...)
      new(...).call
    end

    def initialize(order:)
      @order = order
    end

    def call
      raise ArgumentError, "Заказ уже отменен" if order.status == "cancelled"
      raise ArgumentError, "Завершенный заказ нельзя отменить" if order.status == "completed"

      Order.transaction do
        order.lock!

        restore_inventory! if order.inventory_committed?

        order.update!(
          status: "cancelled"
        )

        order
      end
    end

    private

    attr_reader :order

    def restore_inventory!
      location =
        order.shop
          .locations
          .active
          .order(:created_at)
          .first

      raise ArgumentError, "Не найден склад для возврата товара" unless location

      order.order_items.includes(:product).each do |item|
        next unless item.product

        level =
          InventoryLevel
            .lock
            .find_or_create_by!(
              product: item.product,
              location: location
            )

        level.update!(
          quantity: level.quantity + item.quantity
        )

        InventoryMovement.create!(
          product: item.product,
          location: location,
          quantity_change: item.quantity,
          operation: "return",
          comment: "Отмена заказа #{order.number}"
        )
      end
    end
  end
end
