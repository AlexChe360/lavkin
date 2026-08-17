module Storefront
  class BaseController < ApplicationController
    allow_unauthenticated_access

    layout "storefront"

    before_action :set_shop
    before_action :set_cart

    private

    def set_shop
      @shop =
        Shop.find_by!(
          slug: shop_slug,
          status: :active
        )
    end

    def shop_slug
      params[:shop_slug] || params[:slug]
    end

    def set_cart
      token =
        session[:storefront_cart_token]

      @cart =
        if token.present?
          @shop.carts.find_by(
            token: token
          )
        end

      return if @cart.present?

      @cart =
        @shop.carts.create!(
          token: SecureRandom.hex(24)
        )

      session[:storefront_cart_token] =
        @cart.token
    end
  end
end
