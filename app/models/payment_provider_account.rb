class PaymentProviderAccount < ApplicationRecord
  belongs_to :account

  enum :provider, {
    freedom_pay: "freedom_pay"
  }

  enum :status, {
    draft: "draft",
    pending: "pending",
    connected: "connected",
    rejected: "rejected",
    disabled: "disabled"
  }

  validates :provider,
            presence: true,
            uniqueness: {
              scope: :account_id
            }

  def provider_name
    case provider
    when "freedom_pay"
      "Freedom Pay"
    else
      provider.to_s.humanize
    end
  end

  def status_name
    case status
    when "draft"
      "Не подключено"
    when "pending"
      "Заявка на рассмотрении"
    when "connected"
      "Подключено"
    when "rejected"
      "Отклонено"
    when "disabled"
      "Отключено"
    else
      status
    end
  end
end
