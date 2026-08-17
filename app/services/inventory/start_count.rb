module Inventory
  class StartCount
    def self.call(...)
      new(...).call
    end

    def initialize(inventory_count:)
      @inventory_count = inventory_count
    end

    def call
      raise ArgumentError,
            "Инвентаризация уже начата" unless inventory_count.status == "draft"

      InventoryCount.transaction do
        inventory_count.lock!

        products =
          inventory_count
            .shop
            .products
            .active
            .order(:name)

        levels =
          InventoryLevel
            .where(
              location: inventory_count.location,
              product_id: products.select(:id)
            )
            .index_by(&:product_id)

        products.each do |product|
          level =
            levels[product.id]

          quantity = level&.quantity || 0

          inventory_count.inventory_count_items.create!(
            product: product,
            expected_quantity: quantity,
            actual_quantity: quantity
          )
        end

        inventory_count.update!(
          status: "counting",
          started_at: Time.current
        )

        inventory_count
      end
    end

    private

    attr_reader :inventory_count
  end
end
