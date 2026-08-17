class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_current_account
  before_action :set_current_shop

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def set_current_account
    return unless Current.user

    membership =
      if session[:current_account_id].present?
        Current.user
              .memberships
              .includes(:account)
              .find_by(
                account_id: session[:current_account_id]
              )
      end

    membership ||=
      Current.user
            .memberships
            .includes(:account)
            .first

    return unless membership

    Current.membership = membership
    Current.account = membership.account

    session[:current_account_id] =
      Current.account.id
  end

  def set_current_shop
    return unless Current.account

    Current.shop =
      shop_from_session ||
      Current.account.shops.first

    session[:current_shop_id] =
      Current.shop.id if Current.shop
  end

  def shop_from_session
    return if session[:current_shop_id].blank?

    Current.account.shops.find_by(
      id: session[:current_shop_id]
    )
  end
end
