module Inventory
  class CompleteTransfer
    def self.call(...)
      new(...).call
    end

    def initialize(transfer:)
      @transfer = transfer
    end

    def call
      raise ArgumentError, "Перемещение уже завершено" if transfer.status == "completed"
      raise ArgumentError, "В перемещении нет товаров" if transfer.stock_transfer_items.empty?

      StockTransfer.transaction do
        transfer.lock!

        transfer.stock_transfer_items.each do |item|
          transfer_item!(item)
        end

        transfer.update!(
          status: "completed",
          completed_at: Time.current
        )

        transfer
      end
    end

    private

    attr_reader :transfer

    def transfer_item!(item)
      source_level =
        InventoryLevel
          .lock
          .find_or_create_by!(
            product: item.product,
            location: transfer.source_location
          )

      destination_level =
        InventoryLevel
          .lock
          .find_or_create_by!(
            product: item.product,
            location: transfer.destination_location
          )

      if source_level.quantity < item.quantity
        raise ArgumentError,
              "Недостаточно товара «#{item.product.name}» на складе «#{transfer.source_location.name}»"
      end

      source_level.update!(
        quantity: source_level.quantity - item.quantity
      )

      destination_level.update!(
        quantity: destination_level.quantity + item.quantity
      )

      InventoryMovement.create!(
        product: item.product,
        location: transfer.source_location,
        quantity_change: -item.quantity,
        operation: "transfer_out",
        comment: "Перемещение #{transfer.number} → #{transfer.destination_location.name}"
      )

      InventoryMovement.create!(
        product: item.product,
        location: transfer.destination_location,
        quantity_change: item.quantity,
        operation: "transfer_in",
        comment: "Перемещение #{transfer.number} ← #{transfer.source_location.name}"
      )
    end
  end
end
