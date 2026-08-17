module Orders
  class CommitInventory
    def self.call(...)
      new(...).call
    end

    def initialize(order:)
      @order = order
    end

    def call
      raise ArgumentError, "Остатки заказа уже списаны" if order.inventory_committed?

      Order.transaction do
        order.lock!

        location =
          order.shop
               .locations
               .active
               .order(:created_at)
               .first

        raise ArgumentError, "У магазина нет активного склада" unless location

        order.order_items.includes(:product).each do |item|
          commit_item!(
            item: item,
            location: location
          )
        end

        order.update!(
          inventory_committed_at: Time.current
        )

        order
      end
    end

    private

    attr_reader :order

    def commit_item!(item:, location:)
      raise ArgumentError, "Товар удалён" unless item.product

      level =
        InventoryLevel
          .lock
          .find_or_create_by!(
            product: item.product,
            location: location
          )

      if level.quantity < item.quantity
        raise ArgumentError,
              "Недостаточно товара «#{item.product_name}»"
      end

      level.update!(
        quantity: level.quantity - item.quantity
      )

      InventoryMovement.create!(
        product: item.product,
        location: location,
        quantity_change: -item.quantity,
        operation: "sale",
        comment: "Заказ #{order.number}"
      )
    end
  end
end
