module Admin
  class PaymentsController < AdminController
    before_action :require_owner!
    before_action :set_account

    def show
      @legal_profile =
        @account.business_legal_profile

      @freedom_pay =
        @account.freedom_pay_account
    end

    def connect_freedom_pay
      legal_profile =
        @account.business_legal_profile

      unless legal_profile&.complete_for_payments?
        redirect_to admin_business_settings_path(anchor: "legal"),
                    alert: "Сначала заполните юридические данные",
                    status: :see_other

        return
      end

      provider =
        @account.payment_provider_accounts.find_or_initialize_by(
          provider: "freedom_pay"
        )

      provider.status = "draft"

      provider.save!

      redirect_to admin_payments_path,
                  notice: "Данные готовы для подключения Freedom Pay",
                  status: :see_other
    end

    private

    def set_account
      @account = Current.account
    end
  end
end
