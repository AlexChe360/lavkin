module Admin
  class CategoriesController < AdminController
    before_action :require_manager!
    before_action :require_current_shop
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Current.shop.categories.ordered
    end

    def new
      @category = Current.shop.categories.new
    end

    def create
      @category = Current.shop.categories.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: "Категория создана"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Категория обновлена"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path, notice: "Категория удалена"
      else
        # restrict_with_error: в категории есть товары
        redirect_to admin_categories_path,
                    alert: @category.errors.full_messages.to_sentence
      end
    end

    private

    def set_category
      @category = Current.shop.categories.find(params[:id])
    end

    def category_params
      params
        .require(:category)
        .permit(:name, :slug, :description, :position, :active)
    end

    def require_current_shop
      return if Current.shop.present?

      redirect_to admin_shops_path, alert: "Сначала выберите магазин"
    end
  end
end
