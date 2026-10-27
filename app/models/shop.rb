class Shop < ApplicationRecord
  include Sluggable

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

  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :slug, uniqueness: true

  def storefront_published?
    storefront_published_at.present?
  end
end
