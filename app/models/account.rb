class Account < ApplicationRecord
  has_many :memberships,
            dependent: :destroy

  has_many :users,
            through: :memberships

  has_many :shops,
           dependent: :destroy

  has_many :member_invitations,
            dependent: :destroy

  has_one :business_legal_profile,
          dependent: :destroy

  has_many :payment_provider_accounts,
         dependent: :destroy

  def legal_profile_complete?
    business_legal_profile&.complete_for_payments? || false
  end

  def freedom_pay_account
    payment_provider_accounts.find_by(
      provider: "freedom_pay"
    )
  end

  validates :name,
            presence: true,
            length: {
              maximum: 120
            }
end
