class Category < ApplicationRecord
  belongs_to :shop

  has_many :products,
            dependent: :nullify

  before_validation :normalize_slug

  validates :name,
            presence: true

  validates :slug,
            presence: true,
            uniqueness: {
              scope: :shop_id
            },
            format: {
              with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/,
              message: "может содержать только латинские буквы, цифры и дефисы"
            }

  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  scope :active,
        -> { where(active: true) }

  scope :ordered,
        -> { order(position: :asc, name: :asc) }

  private

  def normalize_slug
    self.slug =
      slug.to_s
        .strip
        .downcase
        .parameterize
  end
end
