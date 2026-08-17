class InventoryCount < ApplicationRecord
  belongs_to :shop
  belongs_to :location

  has_many :inventory_count_items,
           dependent: :destroy

  accepts_nested_attributes_for :inventory_count_items

  STATUSES = %w[
    draft
    counting
    completed
    cancelled
  ].freeze

  validates :number,
            presence: true,
            uniqueness: {
              scope: :shop_id
            }

  validates :status,
            inclusion: {
              in: STATUSES
            }

  validate :location_belongs_to_shop

  def completed?
    status == "completed"
  end

  def counting?
    status == "counting"
  end

  private

  def location_belongs_to_shop
    return if location.blank? || shop.blank?
    return if location.shop_id == shop_id

    errors.add(
      :location,
      "не принадлежит магазину"
    )
  end
end
