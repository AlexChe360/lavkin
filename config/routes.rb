Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resource :registration,
    only: %i[new create],
    controller: "registrations"

  # Публичное принятие приглашения
  get "/invitations/:token",
      to: "member_invitations#show",
      as: :member_invitation

  post "/invitations/:token/accept",
       to: "member_invitations#accept",
       as: :accept_member_invitation

  get "/email_verification",
    to: "email_verifications#pending",
    as: :email_verification_pending

  get "/email_verifications/:token",
      to: "email_verifications#show",
      as: :email_verification

  post "/email_verifications/resend",
     to: "email_verifications#resend",
     as: :resend_email_verification

  namespace :admin do
    root "dashboard#show"

    resources :shops do
      member do
        post :select
      end
    end

    resource :profile,
        only: %i[show edit update]

    resource :payments,
         only: :show do
      post :connect_freedom_pay,
          on: :collection
    end

    resource :business_settings,
            only: %i[show update] do
               patch :legal,
                on: :collection,
                as: :legal
            end

    resource :account_password,
        only: %i[ edit update ]

    resource :storefront, only: %i[ show update] do
      post :publish
      delete :unpublish
    end

    resources :categories,
            except: :show

    resources :members,
            only: %i[
              index
              edit
              update
            ]

    resources :member_invitations,
              only: %i[
                new
                create
              ]

    resources :products

    get "inventory",
        to: "inventory#index",
        as: :inventory

    get "inventory/movements",
        to: "inventory_movements#index",
        as: :inventory_movements

    resources :inventory_adjustments,
              only: %i[new create]

    resources :orders,
          only: %i[
            index
            show
          ] do
      member do
        post :mark_as_paid
        patch :change_status
        post :cancel
      end
    end

    resources :locations,
          except: :show

    resources :inventory_counts,
          path: "inventory/counts",
          only: %i[
            index
            show
            new
            create
            update
          ] do
      member do
        post :start
        post :complete
      end
    end

    resources :stock_transfers,
          path: "inventory/transfers",
          only: %i[
            index
            show
            new
            create
          ] do
      member do
        post :complete
    end
  end
end

  scope "/store/:shop_slug",
      module: :storefront,
      as: :storefront do
    get "/",
        to: "home#show",
        as: :root

    get "/products/:slug",
        to: "products#show",
        as: :product

    resource :cart,
            only: :show

    resources :cart_items,
              only: %i[
                create
                update
                destroy
              ] do
                patch :increment
                patch :decrement
              end

    resource :checkout,
           only: %i[
             show
             create
           ]

    get "/orders/:number",
      to: "orders#show",
      as: :order
  end



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
