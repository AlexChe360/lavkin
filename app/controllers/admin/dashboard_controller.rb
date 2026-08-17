module Admin
  class DashboardController < AdminController
    def show
      @has_shop =
        Current.account.shops.exists?

      @products_count =
        Current.shop&.products&.count || 0

      @has_product =
        @products_count.positive?

      @has_inventory =
        Current.shop.present? &&
        Current.shop.locations.exists?

      @inventory_count =
        if Current.shop
          InventoryLevel
            .joins(:product)
            .where(
              products: {
                shop_id: Current.shop.id
              }
            )
            .sum(:quantity)
        else
          0
        end

      @orders_today_count =
        if Current.shop
          Current.shop
                .orders
                .where(
                  created_at: Time.current.all_day
                )
                .count
        else
          0
        end

      @sales_today =
        if Current.shop
          Current.shop
                .orders
                .where(
                  created_at: Time.current.all_day,
                  status: "paid"
                )
                .sum(:total_amount)
        else
          0
        end

      @recent_orders =
        if Current.shop
          Current.shop
                .orders
                .order(created_at: :desc)
                .limit(5)
        else
          Order.none
        end

      @has_storefront =
        Current.shop.present? &&
        Current.shop.active?

      @has_acquiring =
        false
    end
  end
end
