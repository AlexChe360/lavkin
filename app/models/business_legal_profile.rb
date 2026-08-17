class BusinessLegalProfile < ApplicationRecord
  belongs_to :account

  enum :legal_type, {
    ip: "ip",
    too: "too",
    ao: "ao",
    other: "other"
  }

  validates :legal_type,
            presence: true

  validates :legal_name,
            presence: true

  validates :bin_iin,
            presence: true,
            format: {
              with: /\A\d{12}\z/,
              message: "должен содержать 12 цифр"
            }

  validates :ceo_email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            allow_blank: true

  def legal_type_name
    case legal_type
    when "ip"
      "ИП"
    when "too"
      "ТОО"
    when "ao"
      "АО"
    when "other"
      "Другое"
    else
      "—"
    end
  end

  def complete_for_payments?
    [
      legal_type,
      legal_name,
      bin_iin,
      iban,
      country,
      postal_code,
      city,
      street,
      building,
      ceo_first_name,
      ceo_last_name,
      ceo_phone,
      ceo_email
    ].all?(&:present?)
  end

  def full_ceo_name
    [
      ceo_last_name,
      ceo_first_name,
      ceo_middle_name
    ]
      .compact_blank
      .join(" ")
  end

  def full_address
    [
      postal_code,
      city,
      street,
      building,
      office
    ]
      .compact_blank
      .join(", ")
  end
end
