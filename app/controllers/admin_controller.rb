class AdminController < ApplicationController
  layout "admin"

  before_action :require_current_account

  private

  def require_current_account
    return if Current.account.present?

    redirect_to root_path,
                alert: "Бизнес-аккаунт не найден."
  end

  def requeire_current_shop
    return if Current.shop.present?

    redirect_to admin_shops_path,
              alert: "Выберите магазин"
  end

  def current_membership
    Current.membership
  end

  def require_owner!
    return if current_membership&.owner?

    redirect_to admin_root_path,
                alert: "Недостаточно прав"
  end

  def require_admin!
    return if current_membership&.owner? ||
              current_membership&.admin?

    redirect_to admin_root_path,
                alert: "Недостаточно прав"
  end

  def require_manager!
    return if current_membership&.owner? ||
              current_membership&.admin? ||
              current_membership&.manager?

    redirect_to admin_root_path,
                alert: "Недостаточно прав"
  end

  def require_inventory_management!
    return if current_membership&.owner? ||
              current_membership&.admin?
      redirect_to admin_root_path,
                alert: "Недостаточно прав"
  end
end
