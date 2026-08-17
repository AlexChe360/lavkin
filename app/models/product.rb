class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category,
              optional: true

  has_rich_text :description
  has_one_attached :image

  has_many :inventory_levels,
            dependent: :destroy

  has_many :locations,
            through: :inventory_levels

  has_many :inventory_movements,
            dependent: :restrict_with_error

  def inventory_level_at(location)
    inventory_levels.find_by(
      location: location
    )
  end

  def quantity_at(location)
    inventory_level_at(location)&.quantity || 0
  end

  before_validation :normalize_slug
  before_validation :normalize_sku

  validates :name,
            presence: true

  validates :slug,
            presence: true,
            uniqueness: {
              scope: :shop_id
            }

  validates :sku,
            presence: true,
            uniqueness: {
              scope: :shop_id
            }

  validates :price,
            numericality: {
              greater_than_or_equal_to: 0
            }

  scope :active,
          -> { where(active: true) }

  scope :featured,
          -> { where(featured: true) }

  private

  def normalize_slug
    self.slug =
      slug.to_s
        .strip
        .downcase
        .parameterize
  end

  def normalize_sku
    self.sku =
      sku.to_s
        .strip
        .upcase
  end
end
