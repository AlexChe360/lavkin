module Admin
  class ShopsController < AdminController
    before_action :require_admin!
    before_action :set_shop,
                  only: %i[
                    show
                    edit
                    update
                    destroy
                    select
                  ]

    def index
      @shops =
        Current.account
                .shops
                .order(created_at: :desc)
    end

    def show
    end

    def new
      @shop = Current.account.shops.new
    end

    def create
      @shop =
        Current.account
                .shops
                .new(shop_params)

      if @shop.save
        session[:current_shop_id] = @shop.id

        redirect_to admin_shop_path(@shop),
                    notice: "Магазин создан"
      else
        render :new,
                status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @shop.update(shop_params)
        redirect_to admin_shop_path(@shop),
                    notice: "Магазин обновлён"
      else
        render :edit,
                status: :unprocessable_entity
      end
    end

    def destroy
      shop_id = @shop.id
      @shop.destroy!

      if session[:current_shop_id] == shop_id
        session.delete(
          :current_shop_id
        )
      end

      redirect_to admin_shops_path,
                  notice: "Магазин удален"
    end

    def select
      session[:current_shop_id] =
        @shop.id

        redirect_back fallback_location:
          admin_root_path
    end

    private

    def set_shop
      @shop =
        Current.account
              .shops
              .find(params[:id])
    end

    def shop_params
      params
        .require(:shop)
        .permit(
          :name,
          :slug,
          :description,
          :status
        )
    end
  end
end
