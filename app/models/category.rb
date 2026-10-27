class Category < ApplicationRecord
  include Sluggable
  self.slug_scope_column = :shop_id

  belongs_to :shop

  # products.category_id в базе NOT NULL, поэтому dependent: :nullify
  # приводил бы к 500 при удалении категории. Запрещаем удаление,
  # пока в категории есть товары.
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true

  validates :slug, uniqueness: { scope: :shop_id }

  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(position: :asc, name: :asc) }
end
