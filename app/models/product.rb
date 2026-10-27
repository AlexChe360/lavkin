class Product < ApplicationRecord
  include Sluggable
  self.slug_scope_column = :shop_id

  belongs_to :shop
  # Категория обязательна: колонка products.category_id в базе NOT NULL
  belongs_to :category

  has_rich_text :description
  has_one_attached :image

  has_many :inventory_levels, dependent: :destroy
  has_many :locations, through: :inventory_levels
  has_many :inventory_movements, dependent: :restrict_with_error

  before_validation :normalize_sku

  validates :name, presence: true

  validates :slug, uniqueness: { scope: :shop_id }

  validates :sku,
            presence: true,
            uniqueness: { scope: :shop_id }

  validates :price,
            numericality: { greater_than_or_equal_to: 0 }

  validate :category_belongs_to_shop

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }

  def inventory_level_at(location)
    inventory_levels.find_by(location: location)
  end

  def quantity_at(location)
    inventory_level_at(location)&.quantity || 0
  end

  private

  def normalize_sku
    self.sku = sku.to_s.strip.upcase
  end

  # Нельзя выбрать категорию другого магазина
  def category_belongs_to_shop
    return if category.blank? || shop_id.blank?

    errors.add(:category, :invalid) if category.shop_id != shop_id
  end
end
