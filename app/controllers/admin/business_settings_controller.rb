module Admin
  class BusinessSettingsController < AdminController
    before_action :require_owner!
    before_action :set_account
    before_action :set_legal_profile

    def show
    end

    # Только основные настройки Account
    def update
      if @account.update(account_params)
        redirect_to admin_business_settings_path,
                    notice: "Основные настройки сохранены",
                    status: :see_other
      else
        render :show,
               status: :unprocessable_entity
      end
    end

    # Только юридические данные
    def legal
      if @legal_profile.update(legal_profile_params)
        redirect_to admin_business_settings_path(anchor: "legal"),
                    notice: "Юридические данные сохранены",
                    status: :see_other
      else
        render :show,
               status: :unprocessable_entity
      end
    end

    private

    def set_account
      @account = Current.account
    end

    def set_legal_profile
      @legal_profile =
        @account.business_legal_profile ||
        @account.build_business_legal_profile
    end

    def account_params
      params
        .require(:account)
        .permit(
          :name,
          :email,
          :phone,
          :timezone,
          :currency
        )
    end

    def legal_profile_params
      params
        .require(:business_legal_profile)
        .permit(
          :legal_type,
          :legal_name,
          :bin_iin,
          :iban,
          :country,
          :postal_code,
          :city,
          :street,
          :building,
          :office,
          :ceo_first_name,
          :ceo_last_name,
          :ceo_middle_name,
          :ceo_phone,
          :ceo_email,
          :description
        )
    end
  end
end
