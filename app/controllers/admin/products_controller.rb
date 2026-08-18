module Admin
  class ProductsController < AdminController
    before_action :require_manager!,
                  only: %i[
                    new
                    create
                    edit
                    update
                  ]
    before_action :require_current_shop
    before_action :set_product,
                  only: %i[
                    show
                    edit
                    update
                    destroy
                  ]

    def index
      @products =
        Current.shop
              .products
              .includes(:category)
              .order(created_at: :desc)
    end

    def show
      @locations =
        Current.shop
              .locations
              .active
              .order(:name)

      @inventory_levels =
        InventoryLevel
          .where(
            product: @product,
            location: @locations
          )
          .index_by(&:location_id)
    end

    def new
      @product = Current.shop.products.new
    end

    def create
      @product =
        Current.shop
              .products
              .new(product_params)

      if @product.save
        redirect_to admin_product_path(@product),
                    notice: "Товар создан"
      else
        render :new,
                status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product),
                    notice: "Товар обнавлен"
      else
        render :edit,
              status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy!

      redirect_to admin_products_path,
                notice: "Товар удален"
    end

    private

    def set_product
     @product =
        Current.shop
              .products
              .find(params[:id])
    end

    def product_params
      params
        .require(:product)
        .permit(
          :name,
          :slug,
          :sku,
          :category_id,
          :price,
          :compare_at_price,
          :active,
          :featured,
          :description,
          :image
        )
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path,
                alert: "Сначала выберите магазин"
    end
  end
end
