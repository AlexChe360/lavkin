class StockTransfer < ApplicationRecord
  belongs_to :shop

  belongs_to :source_location,
             class_name: "Location"

  belongs_to :destination_location,
             class_name: "Location"

  has_many :stock_transfer_items,
           dependent: :destroy

  accepts_nested_attributes_for :stock_transfer_items

  STATUSES = %w[
    draft
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

  validate :locations_are_different
  validate :locations_belong_to_shop

  private

  def locations_are_different
    return if source_location_id.blank? ||
              destination_location_id.blank?

    return unless source_location_id == destination_location_id

    errors.add(
      :destination_location,
      "должен отличаться от склада-источника"
    )
  end

  def locations_belong_to_shop
    return if shop.blank?

    if source_location &&
       source_location.shop_id != shop_id
      errors.add(
        :source_location,
        "не принадлежит магазину"
      )
    end

    if destination_location &&
       destination_location.shop_id != shop_id
      errors.add(
        :destination_location,
        "не принадлежит магазину"
      )
    end
  end
end
