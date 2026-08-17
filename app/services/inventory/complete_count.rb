module Inventory
  class CompleteCount
    def self.call(...)
      new(...).call
    end

    def initialize(inventory_count:)
      @inventory_count = inventory_count
    end

    def call
      raise ArgumentError,
            "Инвентаризация уже завершена" if inventory_count.completed?

      raise ArgumentError,
            "Инвентаризация не начата" unless inventory_count.counting?

      if inventory_count
           .inventory_count_items
           .where(actual_quantity: nil)
           .exists?
        raise ArgumentError,
              "Не заполнено фактическое количество для всех товаров"
      end

      InventoryCount.transaction do
        inventory_count.lock!

        inventory_count
          .inventory_count_items
          .includes(:product)
          .each do |item|
          next if item.difference.zero?

          level =
            InventoryLevel
              .lock
              .find_or_create_by!(
                product: item.product,
                location: inventory_count.location
              )

          level.update!(
            quantity: item.actual_quantity
          )

          InventoryMovement.create!(
            product: item.product,
            location: inventory_count.location,
            quantity_change: item.difference,
            operation: "adjustment",
            comment: "Инвентаризация #{inventory_count.number}"
          )
        end

        inventory_count.update!(
          status: "completed",
          completed_at: Time.current
        )

        inventory_count
      end
    end

    private

    attr_reader :inventory_count
  end
end
