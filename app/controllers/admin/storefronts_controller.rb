module Admin
  class StorefrontsController < AdminController
    before_action :require_current_shop
    before_action :set_shop

    def show
    end

    def publish
      @shop.update!(
        storefront_published_at: Time.current
      )

      redirect_to admin_storefront_path,
                  notice: "Интернет-магазин опубликован",
                  status: :see_other
    end

    def unpublish
      @shop.update!(
        storefront_published_at: nil
      )

      redirect_to admin_storefront_path,
                  notice: "Интернет-магазин снят с публикации",
                  status: :see_other
    end

    def update
      if @shop.update(storefront_params)
        redirect_to admin_storefront_path,
                    notice: "Настройки интернет-магазина сохранены",
                    status: :see_other
      else
        render :show,
               status: :unprocessable_entity
      end
    end

    private

    def set_shop
      @shop = Current.shop
    end

    def storefront_params
      params.require(:shop).permit(
        :storefront_description,
        :storefront_show_out_of_stock,
        :storefront_logo,
        :storefront_cover,
        :storefront_accept_orders,
        :storefront_pickup_enabled,
        :storefront_delivery_enabled
      )
    end
  end
end