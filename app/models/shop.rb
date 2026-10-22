class Shop < ApplicationRecord
  SLUG_FORMAT = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

  belongs_to :account

  has_one_attached :storefront_logo
  has_one_attached :storefront_cover

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :carts, dependent: :destroy

  has_many :orders, dependent: :restrict_with_error
  has_many :stock_transfers, dependent: :restrict_with_error
  has_many :inventory_counts, dependent: :restrict_with_error

  has_rich_text :description

  enum :status, {
    draft: 0,
    active: 1,
    archived: 2
  }

  before_validation :normalize_slug

  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :slug,
            presence: true,
            uniqueness: true,
            format: { with: SLUG_FORMAT, allow_blank: true }

  def storefront_published?
    storefront_published_at.present?
  end

  private

  # Slug не введён: берём из названия и при занятости добавляем -2, -3...
  # Slug введён вручную: приводим к виду "latin-lowercase-123" (кириллица
  # транслитерируется), а занятость покажет обычная валидация uniqueness.
  def normalize_slug
    if slug.blank?
      self.slug = unique_slug(Slugifier.call(name))
    else
      self.slug = Slugifier.call(slug)
    end
  end

  def unique_slug(base)
    return base if base.blank?

    candidate = base
    counter = 2

    while Shop.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end

    candidate
  end
end
