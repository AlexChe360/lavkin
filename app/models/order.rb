class Order < ApplicationRecord
  belongs_to :shop

  has_many :order_items,
           dependent: :destroy

  STATUSES = %w[
    awaiting_payment
    paid
    processing
    ready
    completed
    cancelled
  ].freeze

  def inventory_committed?
    inventory_committed_at.present?
  end

  validates :number,
            presence: true,
            uniqueness: {
              scope: :shop_id
            }

  validates :status,
            inclusion: {
              in: STATUSES
            }

  validates :total_amount,
            numericality: {
              greater_than_or_equal_to: 0
            }
end
