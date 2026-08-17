module Inventory
  class AdjustStock
    Result =
      Data.define(
        :level,
        :movement
      )

    def self.call(...)
      new(...).call
    end

    def initialize(
      product:,
      location:,
      quantity:,
      comment: nil
    )
      @product = product
      @location = location
      @quantity = Integer(quantity, 10)
      @comment = comment
    end

    def call
      validate_relationship!

      InventoryLevel.transaction do
        level =
          InventoryLevel
            .lock
            .find_or_create_by!(
              product: product,
              location: location
            )

        old_quantity = level.quantity

        quantity_change =
          quantity - old_quantity

        return Result.new(
          level: level,
          movement: nil
        ) if quantity_change.zero?

        level.update!(
          quantity: quantity
        )

        movement =
          InventoryMovement.create!(
            product: product,
            location: location,
            quantity_change: quantity_change,
            operation: "adjustment",
            comment: comment
          )

        Result.new(
          level: level,
          movement: movement
        )
      end
    end

    private

    attr_reader(
      :product,
      :location,
      :quantity,
      :comment
    )

    def validate_relationship!
      unless product.shop_id == location.shop_id
        raise ArgumentError,
              "Товар и склад должны принадлежать одному магазину"
      end

      if quantity.negative?
        raise ArgumentError,
              "Остаток не может быть отрицательным"
      end
    end
  end
end
